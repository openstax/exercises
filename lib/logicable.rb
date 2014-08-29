module Logicable
  module ActiveRecord
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def logicable(*languages)
        class_exec do
          has_one :logic, as: :parent, dependent: :destroy
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Logicable::ActiveRecord
