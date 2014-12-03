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
          peers_mname = "#{onname}_peers"
          before_validation_mname = "#{onname}_before_validation"
          after_save_mname = "#{onname}_after_save"
          next_by_mname = "next_by_#{onname}"
          prev_by_mname = "prev_by_#{onname}"
          compact_peers_mname = "compact_#{onname}_peers"

          class_exec do
            before_validation before_validation_mname
            after_save after_save_mname

            define_method peers_mname do
              return send(container).send(inverse_of) \
                unless container.nil? || inverse_of.nil?

              relation = self.class.unscoped
              [scope].flatten.compact.each do |s|
                relation = relation.where(s => send(s))
              end
              relation
            end

            define_method before_validation_mname do
              val = send(on)

              if val.nil?
                peers = send(peers_mname)
                next_val = (peers.to_a.max_by{|r| r.send(on) || 0}
                                      .try(on) || 0) + 1
                send(setter_mname, next_val)
              else
                peers = send(peers_mname)
                if peers.to_a.any?{|p| p != self && p.send(on) == val}
                  peers.where{__send__(on) >= val}.reorder(nil)
                       .update_all("#{onname} = - (#{onname} + 1)")
                end
              end
            end

            define_method after_save_mname do
              peers = send(peers_mname)
              peers.reload if peers.where{__send__(on) < 0}.reorder(nil)
                                   .update_all("#{onname} = - #{onname}") > 0
            end

            define_method next_by_mname do
              val = send(on)
              send(peers_mname).where{__send__(on) > val}.first
            end

            define_method prev_by_mname do
              val = send(on)
              send(peers_mname).where{__send__(on) < val}.last
            end

            define_method compact_peers_mname do
              mysql = \
                defined?(ActiveRecord::ConnectionAdapters::MysqlAdapter) && \
                ActiveRecord::Base.connection.instance_of?(
                  ActiveRecord::ConnectionAdapters::MysqlAdapter)
              cend = mysql ? 'END CASE' : 'END'
              peers = send(peers_mname)
              cases = peers.to_a.collect.with_index{ |p, i|
                "WHEN #{p.send(on)} THEN #{- (i + 1)}"}.join(' ')
              self.class.transaction do
                peers.reorder(nil)
                     .update_all("#{onname} = CASE #{onname} #{cases} #{cend}")
                peers.reorder(nil).update_all("#{onname} = - #{onname}")
              end
              peers.reload
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
