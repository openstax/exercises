namespace :cron do
  task minute: :log_to_stdout do
    Rails.logger.debug 'Starting minute cron'

    Rails.logger.info 'rake openstax:accounts:sync:accounts'
    OpenStax::RescueFrom.this { Rake::Task['openstax:accounts:sync:accounts'].invoke }

    Rails.logger.debug 'Finished minute cron'
  end
end
