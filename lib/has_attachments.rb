module HasAttachments
  module ActiveRecord
    module Base
      def has_attachments
        has_many :attachments, as: :parent, dependent: :destroy, inverse_of: :parent

        Rails.application.config.after_initialize do
          class_exec do
            has_many_attached :images do |image|
              image.variant :large,  resize_to_limit: '720x1080'
              image.variant :medium, resize_to_limit: '360x540'
              image.variant :small,  resize_to_limit: '180x270'
            end
          end
        end
      end
    end
  end

  module Roar
    module Decorator
      def has_attachments(options={})
        property :images,
          readable: true,
          writeable: true,
          setter: ->(req) {
            req[:doc]['images'].each do |img|
              unless self.images.detect{|i| i.signed_id == img['signed_id'] }
                self.images.attach(img['signed_id'])
              end
            end
          },
          getter: ->(*) {
            self.images.map do |i|
              i.as_json(only: [:created_at], methods: [:signed_id]).merge(
                'url' => Rails.application.routes.url_helpers.rails_storage_proxy_url(i, {
                  host: Rails.application.secrets.attachments_url
                })
              )
            end
          }
      end
    end
  end
end

ActiveRecord::Base.extend HasAttachments::ActiveRecord::Base
Roar::Decorator.extend HasAttachments::Roar::Decorator
