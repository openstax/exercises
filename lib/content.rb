require 'ose_markup'

module Content
  # Set this to true for tests where
  # the content should be parsed,
  # then set to false afterwards
  mattr_accessor :enable_test_parser

  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def content(names = 'content')
      names_array = names.is_a?(Array) ? names.collect{|name| name.to_s} : [names.to_s]

      class_eval do
        cattr_accessor :content_field_names
        self.content_field_names = names_array

        names_array.each do |name|
          attr_accessible name.to_sym
        end

        before_validation :parse_and_cache_content

        def summary
          return "" if content.blank?
          return content if content.length <= 16
          "#{content[0..15]} ..."
        end

        def parse_and_cache_content(force = false)
          return if Rails.env.test? && !Content.enable_test_parser

          content_field_names.each do |name|
            next if !id.nil? && !send(name + '_changed?') && !force

            content_value = send(name)

            if content_value.blank?
              send(name + '_html=', '')
              next
            end

            unless content_value == ActionController::Base.helpers.strip_tags(content_value)
              errors.add(name, "cannot contain HTML.")
              next
            end

            parser = OseParser.new
            transformer = OseHtmlTransformer.new

            begin
              transformed_tree = transformer.apply(parser.parse(content_value), {:attachable => self})
              send(name + '_html=', transformed_tree.force_encoding("UTF-8"))
              # logger.debug {"Cached #{name}: "  + transformed_tree.inspect.to_s}
            rescue Parslet::ParseFailed => error
              # logger.debug {"Parsing #{name} failed: " + parser.error_tree.inspect.to_s}
              errors.add(name, "contains a formatting error.")
            end
          end

          return false unless errors.empty?
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Content
