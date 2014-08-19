module Publishable
  module Migration
    module Columns
      def publishable
        integer :number, null: false
        integer :version, null: false, default: 1
        datetime :published_at
      end
    end

    module Index
      def add_publishable_index(table_name, publishable_scope = [])
        add_index table_name, [publishable_scope].flatten + [:number, :version], unique: true
        add_index table_name, :published_at
      end

      alias_method :add_publishable_indices, :add_publishable_index
      alias_method :add_publishable_indexes, :add_publishable_index
    end
  end
end

ActiveRecord::ConnectionAdapters::TableDefinition.send :include, Publishable::Migration::Columns
ActiveRecord::Migration.send :include, Publishable::Migration::Index
