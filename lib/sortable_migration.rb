module Sortable
  module Migration
    module Columns
      def sortable
        integer :position, null: false
      end
    end

    module Index
      def add_sortable_index(table_name, scope_symbols = nil)
        sort_scope_array = scope_symbols.nil? ? [] : \
          (scope_symbols.is_a?(Array) ? scope_symbols : [scope_symbols])

        add_index table_name, sort_scope_array + [:position], unique: true
      end
    end
  end
end

ActiveRecord::ConnectionAdapters::TableDefinition.send :include, Sortable::Migration::Columns
ActiveRecord::Migration.send :include, Sortable::Migration::Index
