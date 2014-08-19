module Sortable
  module ActiveRecord
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def sortable(scope_symbols = nil)
        class_eval do
          cattr_accessor :sort_scope_array
          self.sort_scope_array = scope_symbols.nil? ? nil : \
            (scope_symbols.is_a?(Array) ? scope_symbols : [scope_symbols])

          before_save :assign_next_position, :unless => :position

          validates_uniqueness_of :position, :scope => scope_symbols

          default_scope order(:position)

          def self.sort(sorted_ids)
            return false unless (sorted_ids.is_a?(Array) && !sorted_ids.empty?)

            sorted_objs = sorted_ids.collect{|i| find(i)}
            sort_scope = sorted_objs.first.sort_scope

            unsorted_objs = sort_scope.all
            sorted_objs &= unsorted_objs
            sorted_objs |= unsorted_objs

            transaction do
              sorted_objs.each_with_index do |obj, index|
                obj.position = index + 1
                next if obj.save
                sort_scope.where(:position => index + 1).where{id != my{obj.id}}.all.each do |conflict|
                  conflict.position = -conflict.position
                  conflict.save!
                end
                obj.save!
              end
            end
          end

          def assign_next_position
            self.position = (sort_scope.maximum(:position) || 0) + 1
          end

          def sort_scope
            sort_scope_array.nil? ? self.class.scoped : self.class.where(Hash[sort_scope_array.map{|s| [s, send(s)]}])
          end
        end
      end
    end
  end

  module TableDefinition
    def sortable
      integer :position, null: false
    end
  end

  module Migration
    def add_sortable_index(table_name, sort_scope = [])
      add_index table_name, [sort_scope].flatten + [:position], unique: true
    end
  end

  module View
    def self.included(base)
      base.class_eval do
        attr_accessor :current_sortable_position
      end
    end

    def sortable_content(sortable_object, name = 'div', classes = '', options = {}, escape = true, &block)
      options = options.merge({:id => "#{sortable_object.class.name.downcase}_#{sortable_object.id}",
                               :class => "#{classes} sortable_content"})
      content_tag(name, nil, options, escape, &block)
    end

    alias_method :sortable_content_tag, :sortable_content

    def sortable_handle(name = 'span', classes = 'ui-icon ui-icon-arrow-4', options = {}, escape = true, &block)
      options = options.merge({:class => "#{classes} sortable_handle"})
      content_tag(name, nil, options, escape, &block)
    end

    alias_method :sortable_handle_tag, :sortable_handle

    def sortable_position(scope_name = '', start_at = 1, name = 'span', classes = '', options = {}, escape = true)
      options = options.merge({:class => "#{classes} sortable_position",
                               :'data-sortable_scope' => scope_name,
                               :'data-sortable_start_at' => start_at})
      self.current_sortable_position ||= {}
      self.current_sortable_position[scope_name] = (current_sortable_position[scope_name] || (start_at - 1)) + 1
      content_tag(name, current_sortable_position[scope_name], options, escape)
    end

    alias_method :sortable_position_tag, :sortable_position
  end
end

ActiveRecord::Base.send :include, Sortable::ActiveRecord
ActiveRecord::ConnectionAdapters::TableDefinition.send :include, Sortable::TableDefinition
ActiveRecord::Migration.send :include, Sortable::Migration
ActionView::Base.send :include, Sortable::View
