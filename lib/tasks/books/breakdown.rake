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

      book = abl.approved_books(archive: archive).find { |book| book.uuid == params[:uuid] }
      root_book_part = loop do
        begin
          break book.root_book_part
        rescue StandardError => exception
          # Sometimes books in the ABL fail to load
          # Retry with an earlier version of archive, if possible
          previous_version = book.archive.previous_version

          # break from the loop if there are no more archive versions to try
          raise exception if previous_version.nil?

          book = OpenStax::Content::Book.new(
            archive: OpenStax::Content::Archive.new(version: previous_version),
            uuid: book.uuid,
            version: book.version,
            slug: book.slug,
            style: book.style,
            min_code_version: book.min_code_version,
            committed_at: book.committed_at
          )

          raise exception unless book.valid?
        end
      end

      recursive_exercise_counts = ->(book_part) do
        result = book_part.parts.map do |part|
          next recursive_exercise_counts(part) unless part.is_a?(OpenStax::Content::Page)

          exercises = Exercise.chainable_latest.published.joins(:tags).where(
            tags: { name: "context-cnxmod:#{part.uuid}" }
          )

          mc_tf_exercises = exercises.joins(:stylings).where(
            stylings: { style: [ Style::MULTIPLE_CHOICE, Style::TRUE_FALSE ] }
          ).pluck(:id)
          fr_exercises = exercises.joins(:stylings).where(stylings: { style: Style::FREE_RESPONSE }).pluck(:id)

          [
            part.uuid,
            'Page',
            part.book_location,
            part.title,
            exercises.count,
            (mc_tf_exercises & fr_exercises).size,
            (mc_tf_exercises - fr_exercises).size,
            (fr_exercises - mc_tf_exercises).size
          ]
        end

        [
          [
            book_part.uuid,
            'Book or Unit or Chapter',
            book_part.book_location,
            book_part.title
          ] + result[3..-1].map(&:sum)
        ] + result
      end

      CSV.open(filename, 'w') do |csv|
        csv << [
          'UUID', 'Type', 'Location in ToC', 'Title', 'Total Exercises', '2-step MC/TF', 'MC/TF only', 'FR only'
        ]

        recursive_exercise_counts(root_book_part).each { |row| csv << row }
      end
    ensure
      # Restore original logger
      Rails.logger = original_logger
    end
  end
end
