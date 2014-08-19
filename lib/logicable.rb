module Logicable
  module ActiveRecord
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def logicable(delegate_to = self)
        class_eval do
        end
      end
    end
  end

  module TableDefinition
    def logicable
      references :logic
    end
  end

  module Migration
    def add_logicable_index(table_name)
      add_index table_name, :logic_id
    end
  end
end

ActiveRecord::Base.send :include, Logicable::ActiveRecord
ActiveRecord::ConnectionAdapters::TableDefinition.send :include, Logicable::TableDefinition
ActiveRecord::Migration.send :include, Logicable::Migration
