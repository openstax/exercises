module Publishable
  module ActiveRecord

    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def publishable(options = {})
      end
    end
  end

  module RoutingMapper
    def publishable
    end
  end
end

ActiveRecord::Base.send :include, Publishable::ActiveRecord
ActionDispatch::Routing::Mapper.send :include, Publishable::RoutingMapper
