namespace :vocab_terms do
  namespace :import do
    # Imports vocab terms from a spreadsheet
    # Arguments are, in order:
    # filename, author's user id, copyright holder's user id, skip_first_row
    # Example: rake vocab_terms:import:xlsx[vocab_terms.xlsx,1,2]
    #          will import vocab terms from vocab_terms.xlsx and
    #          assign the user with ID 1 as the author and
    #          solution author, and the user with ID 2 as the CR holder
    desc "import vocab terms from an xlsx file"
    task :xlsx, [:filename, :author_id, :ch_id, :skip_first_row] => :environment do |t, args|
      # Output import logging info to the console (except in the test environment)
      original_logger = Rails.logger

      begin
        Rails.logger = ActiveSupport::Logger.new(STDOUT) unless Rails.env.test?

        VocabTerms::Import::Xlsx.call(args.to_h)
      ensure
        # Restore original logger
        Rails.logger = original_logger
      end
    end
  end
end
