namespace :exercises do
  namespace :import do
    # Imports exercies from a spreadsheet for Assessments
    # The first row contains column headers. Required columns:
    # UUID (page UUID)
    # Pre or Post
    # Question Stem
    # Answer Choice A
    # Answer Choice B
    # Answer Choice C
    # Answer Choice D
    # Correct Answer (A, B, C or D)
    # Detailed Solution
    desc 'imports exercises from a spreadsheet for Assessments'
    task :assessments, [:filename, :book_uuid] => :environment do |t, args|
      # Output import logging info to the console (except in the test environment)
      original_logger = Rails.logger

      begin
        Rails.logger = ActiveSupport::Logger.new(STDOUT) unless Rails.env.test?

        Exercises::Import::Assessments.call **args.to_h
      ensure
        # Restore original logger
        Rails.logger = original_logger
      end
    end
  end
end
