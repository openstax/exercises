# Common methods for reading spreadsheets
module RowParser
  def split(text, on: /,|\r?\n/)
    text.to_s.split(on).map(&:strip)
  end

  def record_failures
    ActiveRecord::Base.transaction do
      failures = {}

      yield failures

      failures.empty? ? Rails.logger.info('Success!') :
                        Rails.logger.error("Failed rows: #{failures.keys}")
      failures.each { |key, value| Rails.logger.error "Row #{key}: #{value}" }
    end
  end
end
