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

  module Representable
    module Declarative
      def has_attachments
        class_exec do
          collection :attachments,
                     class: Attachment,
                     decorator: Api::V1::AttachmentRepresenter,
                     writeable: true,
                     readable: true,
                     parse_strategy: :sync
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, HasAttachments::ActiveRecord::Base
Representable::Declarative.send :include, HasAttachments::Representable::Declarative
