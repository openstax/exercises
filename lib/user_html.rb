module UserHtml
  mattr_accessor :sanitize_config

  module ActiveRecord
    module Base
      def user_html(*attributes)
        attributes.each do |attribute|
          filter_name = "link_and_sanitize_#{attribute.to_s}"

          class_exec do
            before_validation filter_name

            define_method(filter_name) do
              content = send(attribute)
              return if content.nil?

              linked_content = Rinku.auto_link(content, :urls, 'target="_blank"')
              sanitized_content = Sanitize.fragment(linked_content, UserHtml.sanitize_config)

              send("#{attribute}=", sanitized_content)
            end
          end
        end
      end
    end
  end
end

ActiveRecord::Base.extend UserHtml::ActiveRecord::Base
