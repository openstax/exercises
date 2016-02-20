module HasAttachments
  module ActiveRecord
    module Base
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def has_attachments
          class_exec do
            has_many :attachments, as: :parent, dependent: :destroy
          end
        end
      end
    end
  end

  module Roar
    module Decorator
      def has_attachments(options={})
        collection :attachments,
                   options.merge(
                     class: Attachment,
                     decorator: Api::V1::AttachmentRepresenter,
                     writeable: true,
                     readable: true,
                     parse_strategy: :sync
                   )
      end
    end
  end
end

ActiveRecord::Base.send :include, HasAttachments::ActiveRecord::Base
Roar::Decorator.extend HasAttachments::Roar::Decorator
