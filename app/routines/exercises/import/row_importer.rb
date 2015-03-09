module Exercises
  module Import

    class RowImporter

      DEFAULT_AUTHOR_ID = 1
      DEFAULT_CH_ID = 2
      MATH_REGEX = /\$+[^\$]*\$+/m

      attr_reader :skip_first_row, :author, :copyright_holder

      def split(text, on: ',')
        text.split(on).collect{|t| t.strip}
      end

      def math_tag(math)
        inner_math = math[1..-2]
        tag = 'span'
        if MATH_REGEX =~ inner_math
          inner_math = inner_math[1..-2]
          tag = 'div'
        end

        "<#{tag} data-math=\"#{inner_math.gsub('"', '&quot;')}\">Math</#{tag}>"
      end

      # Converts the word text into Markdown
      def parse(text)
        return nil if text.blank?
        text = text.to_s

        maths = text.scan(MATH_REGEX)
        maths.each do |math|
          text = text.gsub(math, math_tag(math))
        end

        kd = Kramdown::Document.new(text.to_s.strip)
        # If only one <p> tag, remove it and just return the nodes below
        kd.root.children = kd.root.children.first.children \
          if kd.root.children.length == 1 && kd.root.children.first.type == :p
        kd.to_html
      end

      def record_failures
        Exercise.transaction do
          @failures = {}
          yield
          puts "Failures: #{@failures.keys}"
          puts @failures.values.join("\n")
        end
      end

      def import_row(row,index)
        begin
          perform_row_import(row,index)
        rescue ActiveRecord::RecordInvalid=>e
          @failures[index] = e.to_s
        end
      end

      def perform_row_import(row,index)

        book = row[0]
        chapter = row[1]

        los = split(row[2])
        lo_tags = los.collect{|lo| [book, chapter, lo].join('-')}
        exercise_id = row[3]
        exercise_id_tag = [book, chapter, exercise_id].join('-')
        type_tags = split(row[4])
        location_tag = row[5]
        dok_tag = row[6]
        time_tag = row[7]
        display_type_tags = split(row[8])

        tags = [lo_tags, exercise_id_tag, type_tags, location_tag,
                dok_tag, time_tag, display_type_tags].flatten
        list_name = 'test'
        question_stem_content = parse(row[9])

        styles = [Style::MULTIPLE_CHOICE]
        styles << Style::FREE_RESPONSE if display_type_tags.include?('display-free-response')
        explanation = parse(row[10])
        correct_answer_index = row[11].downcase.strip.each_byte.first - 97

        answers = row[12..-1].each_slice(2)

        e = Exercise.new
        e.tags = tags

        q = Question.new
        q.exercise = e
        e.questions << q

        s = Stem.new
        s.content = question_stem_content
        q.stems << s

        styles.each do |style|
          styling = Styling.new
          styling.stylable = s
          styling.style = style
          s.stylings << styling
        end

        if author
          au = Author.new
          au.publication = e.publication
          au.user = author
          e.publication.authors << au
        end

        if copyright_holder
          c = CopyrightHolder.new
          c.publication = e.publication
          c.user = copyright_holder
          e.publication.copyright_holders << c
        end

        answers.each_with_index do |af, j|
          a = parse(af.first)
          f = parse(af.second)
          next if a.blank?
          an = Answer.new
          an.question = q
          an.content = parse(a)

          sa = StemAnswer.new
          sa.stem = s
          sa.answer = an
          sa.correctness = j == correct_answer_index ? 1 : 0
          sa.feedback = parse(f)
          s.stem_answers << sa
        end

        if explanation.present?
          sol = Solution.new(solution_type: SolutionType::DETAILED)
          sol.question = q
          sol.content = explanation
          q.solutions << sol

          if author.present?
            sau = Author.new
            sau.publication = sol.publication
            sau.user = author
            sol.publication.authors << sau
          end

          if copyright_holder.present?
            sc = CopyrightHolder.new
            sc.publication = sol.publication
            sc.user = copyright_holder
            sol.publication.copyright_holders << sc
          end
        end

        e.save!

        list = List.find_by(name: list_name)
        if list.nil?
          puts "Creating new list: #{list_name}."
          list = List.create(name: list_name)

          [author, copyright_holder].compact.uniq.each do |u|
            lo = ListOwner.new
            lo.owner = u
            lo.list = list
            list.list_owners << lo
          end

          list.save!
        end

        le = ListExercise.new
        le.exercise = e
        le.list = list
        list.list_exercises << le
        le.save!

        puts "Created #{index} exercise(s)."
      end


    end

  end
end
