module Credit
  module Migration
    module Columns
      def credit
        integer :credit
      end
    end
  end
end

ActiveRecord::ConnectionAdapters::TableDefinition.send :include, Credit::Migration::Columns
