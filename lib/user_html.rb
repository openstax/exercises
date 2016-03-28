module UserHtml
  mattr_accessor :sanitize_config

  def self.link_and_sanitize(content)
    linked_content = Rinku.auto_link(content, :urls, 'target="_blank"')
    Sanitize.fragment(linked_content, UserHtml.sanitize_config)
  end

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

              send("#{attribute}=", UserHtml.link_and_sanitize(content))
            end
          end
        end
      end
    end
  end
end

ActiveRecord::Base.extend UserHtml::ActiveRecord::Base
