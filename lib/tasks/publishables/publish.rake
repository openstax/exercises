namespace :publishables do
  namespace :publish do

    # Publishes all unpublished exercises and solutions
    # Takes no arguments
    # Example: rake publishables:publish:all
    #          will publish all unpublished exercises and solutions
    desc "publishes all unpublished exercises and solutions"
    task :all => :environment do |t, args|
      # Output import logging info to the console (except in the test environment)
      original_logger = Rails.logger
      begin
        Rails.logger = ActiveSupport::Logger.new(STDOUT) unless Rails.env.test?

        Publishables::Publish::All.call
      ensure
        # Restore original logger
        Rails.logger = original_logger
      end
    end

  end
end
