module UserHtml
  mattr_accessor :sanitize_config

  def self.sanitize(content)
    Sanitize.fragment(content, UserHtml.sanitize_config)
  end

  module ActiveRecord
    module Base
      def user_html(*attributes)
        attributes.each do |attribute|
          filter_name = :"sanitize_#{attribute.to_s}"

          class_exec do
            before_validation filter_name

            define_method(filter_name) do
              content = send(attribute)
              return if content.nil?

              send("#{attribute}=", UserHtml.sanitize(content))
            end
          end
        end
      end
    end
  end
end

ActiveRecord::Base.extend UserHtml::ActiveRecord::Base
