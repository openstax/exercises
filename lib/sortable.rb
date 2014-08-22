module Sortable
  module ActiveRecord
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def sortable(options = {})
      end
    end
  end

  module TableDefinition
    def sortable
      integer :position, null: false
    end
  end

  module Migration
    def add_sortable_index(table_name, sort_scope = [])
      add_index table_name, [sort_scope].flatten + [:position], unique: true
    end
  end
end

ActiveRecord::Base.send :include, Sortable::ActiveRecord
ActiveRecord::ConnectionAdapters::TableDefinition.send :include, Sortable::TableDefinition
ActiveRecord::Migration.send :include, Sortable::Migration
