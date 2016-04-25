module HasAttachments
  module ActiveRecord
    module Base
      def has_attachments
        class_exec do
          has_many :attachments, as: :parent, dependent: :destroy, inverse_of: :parent
        end
      end
    end
  end

  module Roar
    module Decorator
      def has_attachments(options={})
        collection :attachments,
                   {
                     class: Attachment,
                     decorator: Api::V1::AttachmentRepresenter,
                     writeable: false,
                     readable: true
                   }.merge(options)
      end
    end
  end
end

ActiveRecord::Base.extend HasAttachments::ActiveRecord::Base
Roar::Decorator.extend HasAttachments::Roar::Decorator
