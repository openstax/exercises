namespace :exercises do
  namespace :tag do
    # Tags exercises using a spreadsheet
    # Arguments are, in order:
    # filename, [skip_first_row]
    # Example: rake exercises:tag:xlsx[tags.xlsx]
    #          will tag exercises based on tags.xlsx
    desc "tags exercises using an xlsx file"
    task :xlsx, [:filename, :skip_first_row] => :environment do |t, args|
      # Output import logging info to the console (except in the test environment)
      original_logger = Rails.logger
      begin
        Rails.logger = ActiveSupport::Logger.new(STDOUT) unless Rails.env.test?

        Exercises::Tag::Xlsx.call(args.to_h)
      ensure
        # Restore original logger
        Rails.logger = original_logger
      end
    end
  end
end
