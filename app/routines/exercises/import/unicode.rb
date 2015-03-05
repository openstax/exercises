# Imports a unicode tab-delimited txt file saved from Excel
# Arguments are, in order:
# filename, author's user id, copyright holder's user id,
# skip_first_row, column separator and row separator

require 'csv'

module Exercises
  module Import
    class Unicode

      lev_routine

      DEFAULT_AUTHOR_ID = 1
      DEFAULT_CH_ID = 2

      # Converts the word text into Markdown 
      def convert(text)
        return nil if text.nil?
        text.strip
      end

      def split(text, on: ',')
        text.split(on).collect{|t| t.strip}
      end

      # Imports Exercises from a unicode spreadsheet
      def exec(filename: 'exercises.txt',
               author_id: DEFAULT_AUTHOR_ID,
               ch_id: DEFAULT_CH_ID,
               skip_first_row: true,
               col_sep: "\t",
               row_sep: "\r\n")

        puts "Reading from #{filename}."

        author = User.find_by(id: author_id)
        ch = User.find_by(id: ch_id)

        puts "Setting #{author.full_name} as Author"
        puts "Setting #{ch.full_name} as Copyright Holder"

        content = File.read(filename)
        encoding = CharlockHolmes::EncodingDetector.detect(content)[:encoding]
        options = { encoding: encoding, col_sep: col_sep, row_sep: row_sep }

        puts 'Importing exercises. Please wait...'

        i = 0
        CSV.foreach(filename, options) do |row|
          i += 1
          next if i == 1 && skip_first_row

          book = convert(row[0])
          chapter = convert(row[1])
          section = convert(row[2])
          los = split(convert(row[3]))
          lo_tags = los.collect{|lo| [book, chapter, lo].join('-')}
          exercise_id = convert(row[4])
          exercise_id_tag = [book, chapter, exercise_id].join('-')
          type_tags = split(convert(row[5]))
          location_tag = convert(row[6])
          dok_tag = convert(row[7])
          time_tag = convert(row[8])
          display_type_tags = split(convert(row[9]))

          tags = [lo_tags, exercise_id_tag, type_tags, location_tag,
                  dok_tag, time_tag, display_type_tags].flatten
          list_name = 'test'
          content = convert(row[10])
          explanation = convert(row[11])

          styles = [Style::MULTIPLE_CHOICE]
          styles << Style::FREE_RESPONSE \
            if display_type_tags.include?('display-free-response')

          correct_answer_index = row[12].downcase.strip.each_byte.first - 97
          answers = row[13..-1].each_slice(2)

          e = Exercise.new
          e.tags = tags

          q = Question.new
          q.exercise = e
          e.questions << q

          s = Stem.new
          s.content = content
          q.stems << s

          styles.each do |style|
            styling = Styling.new
            styling.stylable = s
            styling.style = style
            s.stylings << styling
          end

          au = Author.new
          au.publication = e.publication
          au.user = author
          e.publication.authors << au

          c = CopyrightHolder.new
          c.publication = e.publication
          c.user = ch
          e.publication.copyright_holders << c

          answers.each_with_index do |a, f, j|
            next if a.blank?
            an = Answer.new
            an.question = q
            an.content = a

            sa = StemAnswer.new
            sa.stem = s
            sa.answer = an
            sa.correctness = j == correct_answer_index ? 1 : 0
            sa.feedback = f
            s.stem_answers << sa
          end

          s = Solution.new(solution_type: SolutionType::DETAILED)
          s.question = q
          s.content = explanation
          q.solutions << s

          sau = Author.new
          sau.publication = s.publication
          sau.user = author
          s.publication.authors << sau

          sc = CopyrightHolder.new
          sc.publication = s.publication
          sc.user = ch
          s.publication.copyright_holders << sc

          e.save!

          list = List.find_by(name: list_name)
          if list.nil?
            puts "Creating new list: #{list_name}."
            list = List.create(name: list_name)

            [author, ch].uniq.each do |u|
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
        end

        puts "Created #{skip_first_row ? i-1 : i} exercise(s)."
      end
    end
  end
end
