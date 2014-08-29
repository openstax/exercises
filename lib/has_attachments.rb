module HasAttachments
  module ActiveRecord
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

ActiveRecord::Base.send :include, HasAttachments::ActiveRecord
