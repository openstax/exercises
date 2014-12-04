module Sortable
  module ActiveRecord
    module Base
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        # Defines methods that are used to sort records
        # Use via sortable_belongs_to or sortable_class
        def sortable_methods(options = {})
          on = options[:on] || :sort_position
          container = options[:container]
          inverse_of = options[:inverse_of]
          scope_array = [options[:scope]].flatten.compact
          onname = on.to_s
          setter_mname = "#{onname}="
          peers_mname = "#{onname}_peers"
          before_validation_mname = "#{onname}_before_validation"
          next_by_mname = "next_by_#{onname}"
          prev_by_mname = "prev_by_#{onname}"
          compact_peers_mname = "compact_#{onname}_peers"

          class_exec do
            before_validation before_validation_mname

            # Returns all the sort peers for this record, including self
            define_method peers_mname do |force_scope_load = false|
              return send(container).send(inverse_of) \
                unless force_scope_load || container.nil? || inverse_of.nil?

              relation = self.class.unscoped
              scope_array.each do |s|
                relation = relation.where(s => send(s))
              end
              relation
            end

            # Assigns the "on" field's value if needed
            # Adds 1 to any conflicting fields
            define_method before_validation_mname do
              val = send(on)
              scope_changed = scope_array.any? { |s|
                                !changed_attributes[s].nil? }

              return unless val.nil? || scope_changed || changes[on]

              peers = send(peers_mname, scope_changed)
              if val.nil?
                # Assign the next available number to the record
                max_val = (peers.loaded? ? \
                            peers.to_a.max_by{|r| r.send(on) || 0}.try(on) : \
                            peers.maximum(on)) || 0
                send(setter_mname, max_val + 1)
              elsif peers.to_a.any? { |p| p != self && p.send(on) == val }
                # Make a gap for the record
                peers.where{__send__(on) >= val}.reorder(nil)
                     .update_all("#{onname} = - (#{onname} + 1)")
                peers.where{__send__(on) < 0}.reorder(nil)
                     .update_all("#{onname} = - #{onname}")

                # Cause peers to load from the DB the next time they are used
                peers.reset
              end
            end

            # Gets the next record among the peers
            define_method next_by_mname do
              val = send(on)
              peers = send(peers_mname)
              peers.loaded? ? \
                peers.to_a.detect{|p| p.send(on) > val} : \
                peers.where{__send__(on) > val}.first
            end

            # Gets the previous record among the peers
            define_method prev_by_mname do
              val = send(on)
              peers = send(peers_mname)
              peers.loaded? ? \
                peers.to_a.reverse.detect{|p| p.send(on) < val} : \
                peers.where{__send__(on) < val}.last
            end

            # TODO: Move to class method or to relation class
            # Renumbers the peers so that their numbers are sequential,
            # starting at 1
            define_method compact_peers_mname do
              mysql = \
                defined?(ActiveRecord::ConnectionAdapters::MysqlAdapter) && \
                ActiveRecord::Base.connection.instance_of?(
                  ActiveRecord::ConnectionAdapters::MysqlAdapter)
              cend = mysql ? 'END CASE' : 'END'

              peers = send(peers_mname)
              cases = peers.to_a.collect.with_index { |p, i|
                "WHEN #{p.send(on)} THEN #{- (i + 1)}"
              }.join(' ')

              self.class.transaction do
                peers.reorder(nil)
                     .update_all("#{onname} = CASE #{onname} #{cases} #{cend}")
                peers.reorder(nil).update_all("#{onname} = - #{onname}")
              end

              # Cause peers to load from the DB the next time they are used
              peers.reset
            end
          end
        end

        # Defines a sortable has_many relation on the container
        def sortable_has_many(records, options = {})
          on = options[:on] || :sort_position

          class_exec do
            has_many records, lambda { order(on) }, options.except(:on)
          end
        end

        # Defines a sortable belongs_to relation on the child records
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

        # Defines a sortable class without a container
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
        # Adds a non-null sortable column on table creation (no index)
        def sortable(options = {})
          options[:null] = false if options[:null].nil?
          on = options.delete(:on) || :sort_position

          integer on, options
        end
      end
    end

    module Migration
      # Adds a non-null sortable column to an existing table (no index)
      def add_sortable_column(table, options = {})
        options[:null] = false if options[:null].nil?
        on = options.delete(:on) || :sort_position

        add_column table, on, :integer, options
      end

      # Adds a unique index covering the sort scope cols in an existing table
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
