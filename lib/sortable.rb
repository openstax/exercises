require 'sortable_migration'

require 'sortable_migration'
require 'sortable_view'

module Sortable
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

ActiveRecord::Base.send :include, Sortable
