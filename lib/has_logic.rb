module HasLogic
  module ActiveRecord
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def has_logic(*languages)
        class_exec do
          has_one :logic, as: :parent, dependent: :destroy
        end
      end
    end
  end

  module Representable
    module Declarative
      def has_logic
        class_exec do

        end
      end
    end
  end
end

ActiveRecord::Base.send :include, HasLogic::ActiveRecord
Representable::Declarative.send :include, HasLogic::Representable::Declarative
