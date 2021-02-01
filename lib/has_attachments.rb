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
        collection :images,
                   {
                     extend: Api::V1::ImageRepresenter,
                     readable: true,
                     writeable: false
                   }.merge(options)
      end
    end
  end
end

ActiveRecord::Base.extend HasAttachments::ActiveRecord::Base
Roar::Decorator.extend HasAttachments::Roar::Decorator
