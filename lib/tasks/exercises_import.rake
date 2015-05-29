# Imports unicode tab-delimited txt file saved from Excel
# Arguments are, in order:
# filename, author's user id, copyright holder's user id,
# skip_first_row, column separator and row separator
# Example: rake exercises:import:unicode[exercises.txt,1,2]
#          will import exercises from exercises.txt and
#          assign the user with ID 1 as the author and
#          solution author, and the user with ID 2 as the CR holder

namespace :exercises do
  namespace :import do

    desc "import an Excel file"
    task :excel, [:filename, :author_id, :ch_id, :skip_first_row] => :environment do |t, args|
      # Output import logging info to the console (except in the test environment)
      original_logger = Rails.logger
      begin
        Rails.logger = ActiveSupport::Logger.new(STDOUT) unless Rails.env.test?

        Exercises::Import::Excel.call(args.to_h)
      ensure
        # Restore original logger
        Rails.logger = original_logger
      end
    end

    desc "import a zip file"
    task :zip, [:zip_filename, :excel_filename,
                :author_id, :ch_id, :skip_first_row] => :environment do |t, args|
      # Output import logging info to the console (except in the test environment)
      original_logger = Rails.logger
      begin
        Rails.logger = ActiveSupport::Logger.new(STDOUT) unless Rails.env.test?

        Exercises::Import::Zip.call(args.to_h)
      ensure
        # Restore original logger
        Rails.logger = original_logger
      end
    end

  end
end
