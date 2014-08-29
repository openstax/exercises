module HasCollaborators
  module ActiveRecord
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def has_collaborators
        class_exec do
          has_many :collaborators, as: :parent, dependent: :destroy
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, HasCollaborators::ActiveRecord
