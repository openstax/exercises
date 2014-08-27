module Sortable
  module ActiveRecord
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def sortable(*sort_scope_attributes)
        class_exec do
          cattr_accessor :sort_scope_attributes
          self.sort_scope_attributes = sort_scope_attributes.flatten

          before_validation :assign_sortable_position

          def sort_scope
            self.class.where(Hash[sort_scope_attributes.collect{|s| [s, send(s)]}])
          end

          def assign_sortable_position
            self.sortable_position ||= (sort_scope.maximum(:sortable_position) || 0) + 1
          end
        end
      end
    end
  end

  module TableDefinition
    def sortable
      integer :sortable_position, null: false
    end
  end

  module Migration
    def add_sortable_index(table_name, sort_scope = [], options = {})
      add_index table_name, [sort_scope].flatten + [:sortable_position],
                {unique: true}.merge(options)
    end
  end
end

ActiveRecord::Base.send :include, Sortable::ActiveRecord
ActiveRecord::ConnectionAdapters::TableDefinition.send :include, Sortable::TableDefinition
ActiveRecord::Migration.send :include, Sortable::Migration
