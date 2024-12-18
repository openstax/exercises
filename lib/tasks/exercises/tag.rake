namespace :exercises do
  namespace :tag do
    desc 'add a module to exercises that are tagged with another module'
    task :import_from_module_map, [:file] => :environment do |t, args|
      Tag.transaction do
        CSV.foreach(args[:file]) do |src_uuid, new_uuid|
          src = Tag.where(name: "context-cnxmod:#{src_uuid}").first
          next unless src

          new_tag = Tag.find_or_create_by(name: "context-cnxmod:#{new_uuid}")
          src.exercise_tags.each do |et|
            exercise = et.exercise
            unless exercise.exercise_tags.where(tag_id: new_tag.id).exists?
              exercise.exercise_tags.create!(tag: new_tag)
              exercise.touch
            end
          end
        end
      end
    end

    # Tags exercises using a spreadsheet
    # Arguments are, in order:
    # filename, [skip_first_row]
    # Example: rake exercises:tag:spreadsheet[tags.xlsx]
    #          will tag exercises based on tags.xlsx
    desc 'tags exercises using a spreadsheet'
    task :spreadsheet, [:filename, :skip_first_row] => :environment do |t, args|
      # Output import logging info to the console (except in the test environment)
      original_logger = Rails.logger

      begin
        Rails.logger = ActiveSupport::Logger.new(STDOUT) unless Rails.env.test?

        Exercises::Tag::Spreadsheet.call(args.to_h)
      ensure
        # Restore original logger
        Rails.logger = original_logger
      end
    end

    # Tags exercises for OpenStax Assessments using a spreadsheet
    # Arguments are, in order:
    # filename, book_uuid
    # Example: rake exercises:tag:assessments[tags.xlsx,12345]
    #          will tag exercises based on tags.xlsx with the book_uuid 12345
    desc 'tags exercises for OpenStax Assessments using a spreadsheet'
    task :assessments, [:filename, :book_uuid] => :environment do |t, args|
      # Output import logging info to the console (except in the test environment)
      original_logger = Rails.logger

      begin
        Rails.logger = ActiveSupport::Logger.new(STDOUT) unless Rails.env.test?

        Exercises::Tag::Assessments.call args.to_h
      ensure
        # Restore original logger
        Rails.logger = original_logger
      end
    end

    # Converts an EOC spreadsheet from the content team to a CSV for exercises:tag:spreadsheet
    desc 'converts an EOC spreadsheet from the content team to a CSV for exercises:tag:spreadsheet'
    task :convert_eoc, [:filename, :book_uuid, :has_units] => :environment do |t, args|
      # Output import logging info to the console (except in the test environment)
      original_logger = Rails.logger

      begin
        Rails.logger = ActiveSupport::Logger.new(STDOUT) unless Rails.env.test?

        Rails.logger.info { "Finding book \"#{args[:book_uuid]}\"" }
        book = FindBook[uuid: args[:book_uuid]]

        get_parts = ->(part) { part.parts.filter { |part| part.is_a?(OpenStax::Content::BookPart) } }

        parts = get_parts.call(book.root_book_part)
        # Skip units if necessary
        has_units = ActiveModel::Type::Boolean.new.cast args[:has_units]
        chapters = has_units ? parts.flat_map { |part| get_parts.call(part) } : parts

        chapter_uuids = chapters.map(&:uuid)

        Rails.logger.info { "Processing \"#{args[:filename]}\"" }

        output_filename = "#{book.slug}.csv"
        chapter_index = nil
        exercise_id_index = nil
        CSV.open(output_filename, 'w') do |csv|
          csv << [ 'Exercise UID', 'Tags...' ]

          ProcessSpreadsheet.call(filename: args[:filename], headers: :downcase) do |headers, row, index|
            chapter_index ||= headers.index { |header| header.include? 'chapter' }
            raise ArgumentError, 'Could not find Chapter column' if chapter_index.nil?

            exercise_id_index ||= headers.index do |header|
              header.include?('assessment') || header.include?('exercise')
            end
            raise ArgumentError, 'Could not find Assessment ID column' if exercise_id_index.nil?

            chapter = row[chapter_index]
            # The value in the Chapter column may be a UUID or a chapter number
            chapter_uuid = chapter_uuids.include?(chapter) ? chapter : chapter_uuids[Integer(chapter) - 1]

            csv << [
              row[exercise_id_index],
              "assessment:practice:https://openstax.org/orn/book:subbook/#{
                args[:book_uuid]}:#{chapter_uuid}"
            ]
          end
        end

        Rails.logger.info { "Output written to \"#{output_filename}\"" }
      ensure
        # Restore original logger
        Rails.logger = original_logger
      end
    end
  end
end
