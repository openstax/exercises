module Publishable
  module Migration
    module Columns
      def publishable
        integer :number, null: false
        integer :version, null: false, default: 1
        belongs_to :license, null: false
        datetime :published_at
      end
    end

    module Index
      def add_publishable_index(table_name)
        add_index table_name, [:number, :version], unique: true
        add_index table_name, :license_id
        add_index table_name, :published_at
      end

      alias_method :add_publishable_indices, :add_publishable_index
    end
  end
end

ActiveRecord::ConnectionAdapters::TableDefinition.send :include, Publishable::Migration::Columns
ActiveRecord::Migration.send :include, Publishable::Migration::Index
