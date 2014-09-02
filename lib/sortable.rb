module Sortable
  module ActiveRecord
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def sortable
        class_exec do
          has_many :sorts, as: :sortable, dependent: :destroy
        end
      end

      def sort_domain
        class_exec do
          has_many :child_sorts, class_name: 'Sort',
                   as: :domain, dependent: :destroy
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Sortable::ActiveRecord
