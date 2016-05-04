namespace :exercises do
  namespace :import do
    namespace :old do
      # Imports exercises from a spreadsheet (old format)
      # Arguments are, in order:
      # filename, author's user id, copyright holder's user id, skip_first_row
      # Example: rake exercises:import:xlsx[exercises.xlsx,1,2]
      #          will import exercises from exercises.xlsx and
      #          assign the user with ID 1 as the author and
      #          solution author, and the user with ID 2 as the CR holder
      desc "import exercises from an xlsx file (old format)"
      task :xlsx, [:filename, :author_id, :ch_id, :skip_first_row] => :environment do |t, args|
        # Output import logging info to the console (except in the test environment)
        original_logger = Rails.logger

        begin
          Rails.logger = ActiveSupport::Logger.new(STDOUT) unless Rails.env.test?

          Exercises::Import::Old::Xlsx.call(args.to_h)
        ensure
          # Restore original logger
          Rails.logger = original_logger
        end
      end

      # Imports exercises from a zip file (old format)
      # Arguments are, in order:
      # filename, author's user id, copyright holder's user id, skip_first_row
      # Example: rake exercises:import:zip[exercises.zip,1,2]
      #          will import exercises from the first xlsx file found within exercises.zip and
      #          assign the user with ID 1 as the author and
      #          solution author, and the user with ID 2 as the CR holder
      desc "import exercises from a zip file (old format)"
      task :zip, [:filename, :author_id, :ch_id, :skip_first_row] => :environment do |t, args|
        # Output import logging info to the console (except in the test environment)
        original_logger = Rails.logger

        begin
          Rails.logger = ActiveSupport::Logger.new(STDOUT) unless Rails.env.test?

          Exercises::Import::Old::Zip.call(args.to_h)
        ensure
          # Restore original logger
          Rails.logger = original_logger
        end
      end

    end
  end
end
