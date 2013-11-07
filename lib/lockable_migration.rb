module Lockable
  module Migration
    module Columns
      def lockable
        belongs_to :locker
        datetime :locked_at
      end
    end
  end
end

ActiveRecord::ConnectionAdapters::TableDefinition.send :include, Lockable::Migration::Columns
