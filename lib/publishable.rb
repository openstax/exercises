module Publishable
  module ActiveRecord

    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def publishable(options = {})
        class_exec do
          has_one :publication, as: :publishable, dependent: :destroy
        end
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
