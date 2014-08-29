module HasLogic
  module ActiveRecord
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def has_logic(*languages)
        class_exec do
          has_one :logic, as: :logicable, dependent: :destroy
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, HasLogic::ActiveRecord
