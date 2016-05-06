# Imports a spreadsheet containing Exercises
module Import
  module ExerciseImporter

    include PublishableImporter
    include RowParser

    # Parses the text using Markdown
    # Attachments are associated with the given Exercise object
    def parse(text, exercise)
      return nil if text.blank?

      text = text.to_s

      kd = Kramdown::Document.new(text.to_s.strip, attachable: exercise)
      # If only one <p> tag, remove it and just return the nodes below
      kd.root.children = kd.root.children.first.children \
        if kd.root.children.length == 1 && kd.root.children.first.type == :p
      kd.to_html
    end

    def import_row(row, row_number)
      id = row[4]

      @id_map ||= {}
      existing_row = @id_map[id]
      raise "Duplicate ID: Rows #{existing_row} and #{row_number}" unless existing_row.nil?
      @id_map[id] = row_number

      ex = Exercise.new

      books = split(row[0])
      book_tags = books.map{ |book| "book:#{book}" }

      chapter = row[1]
      section = row[2]

      lo_tags = split(row[3]).map{ |lo| "lo:#{books.first}:#{chapter}-#{section}-#{lo}" }

      id_tag = "exid:#{books.first}:#{row[4]}"

      cnxmod_tag = "context-cnxmod:#{row[5]}"

      type_tags = split(row[6]).map{ |type| "type:#{type}" }
      dok_tag = "dok:#{row[7]}"
      blooms_tag = "blooms:#{row[8]}"
      time_tag = "time:#{row[10]}"

      ex.tags = book_tags + lo_tags + type_tags + \
                [id_tag, cnxmod_tag, dok_tag, blooms_tag, time_tag]

      latest_exercise = Exercise.joins([:publication, exercise_tags: :tag])
                                .where(exercise_tags: {tag: {name: id_tag}})
                                .order{[publication.number.desc, publication.version.desc]}.first

      unless latest_exercise.nil?
        ex.publication.number = latest_exercise.publication.number
        ex.publication.version = latest_exercise.publication.version + 1
      end

      ex.save! # Need to save before we add attachments (see parse method above)

      question_stem_content = parse(row[14], ex)

      styles = [Style::MULTIPLE_CHOICE]
      styles << Style::FREE_RESPONSE unless row[12].include?('y')
      explanation = parse(row[15], ex)
      correct_answer_index = row[16].downcase.strip.each_byte.first - 97

      answers = row[17..-1].each_slice(2)

      qq = Question.new
      ex.questions << qq

      st = Stem.new(content: question_stem_content)
      qq.stems << st

      styles.each do |style|
        st.stylings << Styling.new(style: style)
      end

      ex.publication.authors << Author.new(user: author) if author
      ex.publication.copyright_holders << CopyrightHolder.new(user: copyright_holder) \
        if copyright_holder

      answers.each_with_index do |af, j|
        aa = parse(af.first, ex)
        ff = parse(af.second, ex)
        next if aa.blank?
        an = Answer.new(question: qq, content: aa)

        correctness = j == correct_answer_index ? 1 : 0
        st.stem_answers << StemAnswer.new(answer: an, correctness: correctness, feedback: ff)
      end

      if explanation.present?
        sol = CollaboratorSolution.new(solution_type: SolutionType::DETAILED, content: explanation)
        qq.collaborator_solutions << sol
      end

      if ex.content_equals?(latest_exercise)
        ex.destroy!

        skipped = true
      else
        list_name = row[13]
        @lists ||= {}
        @lists[list_name] ||= List.find_or_create_by!(name: list_name) do |list|
          [author, copyright_holder].compact.uniq.each do |owner|
            list.list_owners << ListOwner.new(owner: owner)
          end

          Rails.logger.info "Created new list: #{list_name}"
        end
        list = @lists[list_name]

        le = ListExercise.new(list: list, exercise: ex)
        ex.list_exercises << le
        list.list_exercises << le
        ex.save!
        ex.publication.publish.save!

        skipped = false
      end

      row = "Imported row ##{row_number}"
      uid = skipped ? "Existing uid: #{latest_exercise.uid}" : "New uid: #{ex.uid}"
      changes = skipped ? "Exercise skipped (no changes)" : \
                          "New #{latest_exercise.nil? ? 'exercise' : 'version'}"
      Rails.logger.info "#{row} - #{uid} - #{changes}"
    end

  end
end
