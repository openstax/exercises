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

  module TableDefinition
    def publishable
      integer :number, null: false
      integer :version, null: false, default: 1
      references :license
      datetime :published_at
    end
  end

  module Migration
    def add_publishable_index(table_name, publishable_scope = [])
      add_index table_name, [publishable_scope].flatten + [:number, :version], unique: true
      add_index table_name, :license_id
      add_index table_name, :published_at
    end

    alias_method :add_publishable_indices, :add_publishable_index
    alias_method :add_publishable_indexes, :add_publishable_index
  end

  module RoutingMapper
    def publishable
    end
  end
end

ActiveRecord::Base.send :include, Publishable::ActiveRecord
ActiveRecord::ConnectionAdapters::TableDefinition.send :include, Publishable::TableDefinition
ActiveRecord::Migration.send :include, Publishable::Migration
ActionDispatch::Routing::Mapper.send :include, Publishable::RoutingMapper
