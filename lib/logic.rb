module Logic
  module ActiveRecord
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def logic(delegate_to = self)
        class_eval do
        end
      end
    end
  end

  module TableDefinition
    def logic
      references :logic
    end
  end

  module Migration
    def add_logic_index(table_name)
      add_index table_name, :logic_id
    end
  end
end

ActiveRecord::Base.send :include, Logic::ActiveRecord
ActiveRecord::ConnectionAdapters::TableDefinition.send :include, Logic::TableDefinition
ActiveRecord::Migration.send :include, Logic::Migration
