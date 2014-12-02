module Sortable
  module ActiveRecord
    module Base
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def sortable_methods(options = {})
          on = options[:on] || :sort_position
          container = options[:container]
          inverse_of = options[:inverse_of]
          scope = options[:scope]
          onname = on.to_s
          setter_mname = "#{onname}="
          siblings_mname = "#{onname}_siblings"
          set_to_mname = "set_#{onname}_to"
          filter_mname = "#{onname}_filter"

          class_exec do
            before_validation filter_mname

            define_method siblings_mname do
              return send(container).send(inverse_of) \
                unless container.nil? || inverse_of.nil?

              relation = self.class.unscoped
              [scope].flatten.compact.each do |s|
                relation = relation.where(s => send(s))
              end
              relation
            end

            define_method set_to_mname do |new_val|
              ss = send(siblings_mname).reorder(nil)
              old_val = send(on)
              return if !old_val.nil? && (new_val.nil? || new_val == old_val)

              self.class.transaction do
                if new_val.nil?
                  new_val = (ss.maximum(on) || 0) + 1
                elsif old_val.nil?
                  ss.where{(__send__(on) >= new_val)}
                    .update_all("#{onname} = - (#{onname} + 1)")
                elsif new_val > old_val
                  ss.where{(__send__(on) > old_val) & \
                           (__send__(on) <= new_val)}
                    .update_all("#{onname} = - (#{onname} - 1)")
                else
                  ss.where{(__send__(on) >= new_val) & \
                           (__send__(on) < old_val)}
                    .update_all("#{onname} = - (#{onname} + 1)")
                end
                update_column(onname, new_val)
                ss.where{__send__(on) <= 0}
                  .update_all("#{onname} = - #{onname}")
              end
            end

            define_method filter_mname do
              return unless send(on).nil?

              next_val = (send(siblings_mname).to_a.max_by{|r| r.send(on) || 0}
                                              .try(on) || 0) + 1
              send(setter_mname, next_val)
            end
          end
        end

        def sortable_has_many(records, options = {})
          on = options[:on] || :sort_position

          class_exec do
            has_many records, lambda { order(on) }, options.except(:on)
          end
        end

        def sortable_belongs_to(container, options = {})
          on = options[:on] || :sort_position

          class_exec do
            belongs_to container, options.except(:on, :scope)

            reflection = reflect_on_association(container)
            options[:scope] ||= reflection.polymorphic? ? \
                                  [reflection.foreign_type,
                                   reflection.foreign_key] : \
                                  reflection.foreign_key
            options[:inverse_of] ||= reflection.inverse_of.try(:name)

            validates on, presence: true,
                          numericality: { only_integer: true,
                                          greater_than: 0 },
                          uniqueness: { scope: options[:scope] }
          end

          options[:container] = container
          sortable_methods(options)
        end

        def sortable_class(options = {})
          on = options[:on] || :sort_position
          scope = options[:scope]

          class_exec do
            default_scope { order(on) }

            validates on, presence: true,
                          numericality: { only_integer: true,
                                          greater_than: 0 },
                          uniqueness: (scope.nil? ? true : { scope: scope })
          end

          sortable_methods(options)
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
        options[:unique] = true if options[:unique].nil?
        scope = options.delete(:scope)
        on = options.delete(:on) || :sort_position
        columns = ([scope] << on).flatten.compact

        add_index table, columns, options
      end
    end
  end
end

ActiveRecord::Base.send :include, Sortable::ActiveRecord::Base
ActiveRecord::ConnectionAdapters::TableDefinition.send(
  :include, Sortable::ActiveRecord::ConnectionAdapters::TableDefinition)
ActiveRecord::Migration.send :include, Sortable::ActiveRecord::Migration
