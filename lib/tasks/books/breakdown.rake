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

      all_pages = root_book_part.all_pages
      tags = all_pages.map { |page| "context-cnxmod:#{page.uuid}" }
      exercise_counts_by_tag = Exercise.chainable_latest.published.joins(:tags).where(
        tags: { name: tags }
      ).group(tags: :name).count

      recursive_exercise_counts = ->(book_part) do
        result = book_part.parts.map do |part|
          part.is_a?(OpenStax::Content::Page) ?
            [ part.uuid, exercise_counts_by_tag["context-cnxmod:#{part.uuid}"] || 0 ] : recursive_exercise_counts(part)
        end

        [ book_part.uuid, result.map(&:second).sum ] + result
      end

      CSV.open(filename, 'w') do |csv|
        recursive_exercise_counts(root_book_part).each do |row|
          csv << row
        end
      end
    ensure
      # Restore original logger
      Rails.logger = original_logger
    end
  end
end
