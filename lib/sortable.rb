module Sortable
  module ActiveRecord
    def self.deferred_constraints?
      c = ::ActiveRecord::Base.connection
      @@deferred_constraints ||= \
        (defined?(::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter) && \
         c.is_a?(::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)) || \
        (defined?(::ActiveRecord::ConnectionAdapters::SQLite3Adapter)    && \
         c.is_a?(::ActiveRecord::ConnectionAdapters::SQLite3Adapter))
    end

    module Base
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def sortable_has_many(records, options = {})
          class_sort = (records == :all || records == :unscoped)
          define_mname = class_sort ? :define_singleton_method : \
                                      :define_method
          on = options.delete(:on) || :sort_position
          onname = on.to_s
          rname = records.to_s.singularize
          setter_mname = "#{onname}="
          sort_to_mname = "sort_#{rname}_to"
          sort_before_mname = "sort_#{rname}_before"

          class_exec do
            has_many records, lambda { order(on) }, options unless class_sort

            send(define_mname, sort_to_mname) do |record, *args|
              ss = send(records)
              old_val = record.send(on)
              new_val = args[0] || old_val

              if new_val.nil? # Not saved yet
                maxon = ss.to_a.max_by{|r| r.send(on)}.try(on) || 0
                record.send(setter_mname, maxon + 1)
              elsif Sortable::ActiveRecord.deferred_constraints?
                ss.base_class.transaction do
                  ss.where{__send__(on) > old_val}
                    .update_all("#{onname} = #{onname} - 1") \
                      unless old_val.nil?
                  ss.where{__send__(on) >= new_val}
                    .update_all("#{onname} = #{onname} + 1")
                  record.update_column(onname, new_val)
                end
              else # Workaround in case deferred constraints not supported
                maxon = ss.maximum(on) || 0
                new_neg_val = new_val - maxon
                ss.base_class.transaction do
                  unless old_val.nil?
                    ss.where{__send__(on) < old_val}
                      .update_all("#{onname} = #{onname} - #{maxon}")
                    ss.where{__send__(on) > old_val}
                      .update_all("#{onname} = #{onname} - #{maxon + 1}")
                  end
                  record.update_column(onname, new_val)
                  ss.where{__send__(on) < new_neg_val}
                    .update_all("#{onname} = #{onname} + #{maxon}")
                  ss.where{(__send__(on) >= new_neg_val) & (__send__(on) < 0)}
                    .update_all("#{onname} = #{onname} + #{maxon + 1}")
                end
              end
            end

            send(define_mname, sort_before_mname) do |record, *args|
              send(sort_to_mname, record, args[0].try(on))
            end
          end
        end

        def sortable_belongs_to(container, options = {})
          class_sort = container == :class
          on = options.delete(:on) || :sort_position
          onname = on.to_s
          rname = (options[:inverse_of].try(:to_s) || \
                   name.tableize).singularize
          scope = options[:scope] || \
                    (class_sort ? nil : "#{container.to_s}_id")
          uniqueness = scope.nil? ? true : { scope: scope }
          validation = scope.nil? ? true : scope
          filter_mname = "#{onname}_filter"
          sort_to_mname = "sort_#{rname}_to"

          class_exec do
            belongs_to container, options unless class_sort

            validates on, presence: true,
                          numericality: { only_integer: true,
                                          greater_than: 0 },
                          uniqueness: uniqueness,
                          if: validation

            before_validation filter_mname

            define_method filter_mname do
              return unless send(on).nil?

              send(container).send(sort_to_mname, self)
            end
          end
        end

        def sortable_class(options = {})
          on = options[:on] || :sort_position
          sortable_has_many(:all, options)
          sortable_belongs_to(:class, options.merge(inverse_of: :all))

          class_exec do
            default_scope { order(on) }
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
      def add_sortable_column(table, options = {})
          options[:null] = false if options[:null].nil?
          on = options.delete(:on) || :sort_position

          add_column table, on, :integer, options
      end

      def add_sortable_index(table, options = {})
        options[:unique] = true \
          if options[:unique].nil? && \
             Sortable::ActiveRecord.deferred_constraints?
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
