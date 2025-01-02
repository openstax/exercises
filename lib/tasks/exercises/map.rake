namespace :exercises do
  namespace :map do
    # Maps exercise cnxmod tags using a spreadsheet
    # Arguments are, in order:
    # filename, [skip_first_row]
    # Example: rake exercises:map:spreadsheet[map.xlsx]
    #          will map exercise cnxmod tags based on map.xlsx
    desc "maps exercises cnxmod tags using a spreadsheet"
    task :spreadsheet, [:filename, :skip_first_row] => :environment do |t, args|
      # Output import logging info to the console (except in the test environment)
      original_logger = Rails.logger

      begin
        Rails.logger = ActiveSupport::Logger.new(STDOUT) unless Rails.env.test?

        Exercises::Map::Spreadsheet.call(**args.to_h)
      ensure
        # Restore original logger
        Rails.logger = original_logger
      end
    end
  end
end
