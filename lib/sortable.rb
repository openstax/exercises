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

        before_validation :assign_next_position, :unless => :position

        validates_presence_of :position
        validates_uniqueness_of :position, :scope => scope_symbols

        default_scope order(:position)

        def self.sort(sorted_ids)
          return false unless (sorted_ids.is_a?(Array) && !sorted_ids.empty?)

          ss = sorted_ids.first.sort_scope
          unsorted_ids = ss.select(:id).all
          sorted_ids = sorted_ids & unsorted_ids
          sorted_ids = sorted_ids | unsorted_ids

          index = 0
          conflict_index = (ss.minimum(:position) || 0) - 1

          sorted_ids.each do |sorted_id|
            ss.where(:position => index).all.each do |conflict|
              conflict.position = conflict_index
              conflict.save!
              conflict_index -= 1
            end

            obj = find(sorted_id)
            obj.position = index
            obj.save!
            index += 1
          end
        end

        def assign_next_position
          self.position = ((sort_scope.maximum(:position) || -1) + 1)
        end

        protected

        def sort_scope
          sort_scope_array.nil? ? self.class.scoped : self.class.where(Hash[sort_scope_array.map{|s| [s, send(s)]}])
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Sortable
