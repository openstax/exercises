namespace :books do
  # Creates a CSV file listing the number of Exercises of each type per section of the given book
  # Arguments are, in order:
  # book_uuid, [filename]
  # Example: rake books:breakdown[14fb4ad7-39a1-4eee-ab6e-3ef2482e3e22]
  #          will create 14fb4ad7-39a1-4eee-ab6e-3ef2482e3e22.csv containing book Exercise info for A&P
  desc 'creates a CSV file listing the number of Exercises of each type per section of the given book'
  task :breakdown, [:book_uuid, :filename] => :environment do |t, args|
    # Output logging info to the console (except in the test environment)
    original_logger = Rails.logger

    begin
      Rails.logger = ActiveSupport::Logger.new(STDOUT) unless Rails.env.test?

      book_uuid = args[:book_uuid]
      filename = args[:filename] || "#{book_uuid}.csv"

      book = FindBook[uuid: book_uuid]
      root_book_part = book.root_book_part

      def recursive_exercise_counts(book_part, type)
        results = book_part.parts.flat_map do |part|
          next recursive_exercise_counts(part, 'Unit/Chapter') unless part.is_a?(OpenStax::Content::Page)

          exercises = Exercise.chainable_latest.published.joins(:tags).where(
            tags: { name: "context-cnxmod:#{part.uuid}" }
          ).joins(questions: {stems: :stylings}).distinct

          mc_tf_exercises = exercises.dup.where(
            questions: { stems: { stylings: { style: [ Style::MULTIPLE_CHOICE, Style::TRUE_FALSE ] } } }
          ).pluck(:id)
          fr_exercises = exercises.dup.where(
            questions: { stems: { stylings: { style: Style::FREE_RESPONSE } } }
          ).pluck(:id)

          [
            [
              part.uuid,
              'Page',
              part.book_location.join('.'),
              ActionView::Base.full_sanitizer.sanitize(part.title).gsub(/\s+/, ' ').strip,
              exercises.count,
              (mc_tf_exercises & fr_exercises).size,
              (mc_tf_exercises - fr_exercises).size,
              (fr_exercises - mc_tf_exercises).size
            ]
          ]
        end

        direct_child_uuids = book_part.parts.map(&:uuid)
        direct_child_results = results.filter { |result| direct_child_uuids.include? result.first }

        [
          [
            book_part.uuid,
            type,
            book_part.book_location.join('.'),
            ActionView::Base.full_sanitizer.sanitize(book_part.title).gsub(/\s+/, ' ').strip
          ] + direct_child_results.map { |result| result[4..-1] }.transpose.map(&:sum)
        ] + results
      end

      CSV.open(filename, 'w') do |csv|
        csv << [
          'UUID', 'Type', 'Number', 'Title', 'Total Exercises', '2-step MC/TF', 'MC/TF only', 'FR only'
        ]

        recursive_exercise_counts(root_book_part, 'Book').each { |row| csv << row }
      end
    ensure
      # Restore original logger
      Rails.logger = original_logger
    end
  end
end
