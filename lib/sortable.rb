module Sortable
  module ActiveRecord
    module Base
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        def sortable(options = {})
          on = options[:on] || :sort_position
          container = options[:container]
          if container.nil?
            container = :class
            relation = :all
            uniqueness = true
          else
            relation = options[:relation] || name.tableize
            uniqueness = { scope: options[:scope] || "#{container.to_s}_id" }
          end

          class_exec do
            validates on, presence: true,
                          numericality: { only_integer: true },
                          uniqueness: uniqueness

            before_validation :set_sort_position

            protected

            define_method :set_sort_position do
              return unless send(on).nil?
              sort_siblings = send(container).send(relation).to_a
              max_position = sort_siblings.max_by{|ss| ss.send(on)}
                                          .try(on) || -1
              send("#{on.to_s}=", max_position + 1)
            end
          end
        end
      end
    end

    module ConnectionAdapters
      module TableDefinition
        def sortable(options = {})
          options[:null] = false if options[:null].nil?
          on = options.delete(:on) || :sort_position

          integer on, options
        end
      end
    end

    module Migration
      def add_sortable_index(table, options = {})
        options[:unique] = true if options[:unique].nil?
        scope = options.delete(:scope)
        on = options.delete(:on) || :sort_position
        on = ([scope] << on).flatten unless scope.nil?

        add_index table, on, options
      end
    end
  end
end

ActiveRecord::Base.send :include, Sortable::ActiveRecord::Base
ActiveRecord::ConnectionAdapters::TableDefinition.send(
  :include, Sortable::ActiveRecord::ConnectionAdapters::TableDefinition)
ActiveRecord::Migration.send :include, Sortable::ActiveRecord::Migration
