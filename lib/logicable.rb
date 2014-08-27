module Logicable
  module ActiveRecord
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def logicable(options = {})
      end
    end
  end
end

ActiveRecord::Base.send :include, Logicable::ActiveRecord
