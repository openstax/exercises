namespace :exercises do
  namespace :untag do
    # Remove exercise tags based on a spreadsheet
    # Arguments are, in order:
    # filename, [skip_first_row]
    # Example: rake exercises:untag:spreadsheet[tags.xlsx]
    #          will remove exercise tags based on tags.xlsx
    desc "removes exercise tags based on a spreadsheet"
    task :spreadsheet, [:filename, :skip_first_row] => :environment do |t, args|
      # Output import logging info to the console (except in the test environment)
      original_logger = Rails.logger

      begin
        Rails.logger = ActiveSupport::Logger.new(STDOUT) unless Rails.env.test?

        Exercises::Untag::Spreadsheet.call(**args.to_h)
      ensure
        # Restore original logger
        Rails.logger = original_logger
      end
    end
  end
end
