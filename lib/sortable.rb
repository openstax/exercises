module Sortable
  module ActiveRecord
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def sortable
        class_exec do
          has_many :sortings, as: :sortable, dependent: :destroy
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Sortable::ActiveRecord
