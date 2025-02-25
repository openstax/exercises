# Common methods for reading spreadsheets
module RowParser
  # Parses the text using Markdown
  # Attachments are associated with the given Exercise object
  def parse(text, exercise)
    return nil if text.blank?

    text = text.to_s

    kd = Kramdown::Document.new(text.to_s.strip, math_engine: :openstax, attachable: exercise)
    # If only one <p> tag, remove it and just return the nodes below
    kd.root.children = kd.root.children.first.children \
      if kd.root.children.length == 1 && kd.root.children.first.type == :p
    kd.to_html
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

  def split(text, on: /,|\r?\n/)
    text.to_s.split(on).map(&:strip)
  end
end
