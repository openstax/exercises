namespace :exercises do
  namespace :tag do
    desc "add a module to exercises that are tagged with another module"
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
    desc "tags exercises using a spreadsheet"
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
    # filename, book_uuid, [skip_first_row]
    # Example: rake exercises:tag:assessments[tags.xlsx,12345]
    #          will tag exercises based on tags.xlsx with the book_uuid 12345
    desc "tags exercises for OpenStax Assessments using a spreadsheet"
    task :assessments, [:filename, :book_uuid, :skip_first_row] => :environment do |t, args|
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
    task :convert_eoc, [:book_uuid, :has_units, :filename] => :environment do |t, args|
      Rails.logger.info "Finding book #{args[:book_uuid]}"
      book = FindBook[uuid: args[:book_uuid]]

      get_parts = ->(part) { part.parts.filter { |part| part.is_a?(OpenStax::Content::BookPart) } }

      parts = get_parts.call(book.root_book_part)
      # Skip units if necessary
      chapters = args[:has_units] ? parts.flat_map { |part| get_parts.call(part) } : parts

      chapter_uuid_by_page_uuid = {}
      chapters.each do |chapter|
        chapter.all_pages.each do |page|
          chapter_uuid_by_page_uuid[page.uuid] = chapter.uuid
        end
      end

      output = "#{book.slug}.csv"
      Rails.logger.info "Loading #{args[:filename]} and writing output to #{output}"

      CSV.open(output, 'w') do |csv|
        csv << [ 'Exercise UID', 'Tags...' ]

        ProcessSpreadsheet.call(filename: args[:filename], offset: 2) do |row, index|
          chapter_uuid = chapter_uuid_by_page_uuid[row[0]]
          if chapter_uuid.nil?
            Rails.logger.warn "Skipped row #{index + 1} because page UUID in column 1 was not found"
            next
          end

          if row[3] == 'no'
            Rails.logger.warn "Skipped row #{index + 1} because column 4 says it is not in Exercises"
            next
          end

          if row[4].blank?
            Rails.logger.warn "Skipped row #{index + 1} because column 5 is blank"
            next
          end

          csv << [
            row[4],
            "assessment:practice:https://openstax.org/orn/book:subbook/#{
              book_uuid}:#{chapters[chapter.to_i-1].uuid}"
          ]
        end
      end
    end
  end
end
