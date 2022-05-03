namespace :cron do
  task day: :log_to_stdout do
    Rails.logger.debug 'Starting daily cron'

    Rails.logger.info 'UpdateSlugs.call'
    OpenStax::RescueFrom.this { UpdateSlugs.call }

    Rails.logger.info 'WarmUpCache.call'
    OpenStax::RescueFrom.this { WarmUpCache.call }

    Rails.logger.debug 'Finished daily cron'
  end
end
