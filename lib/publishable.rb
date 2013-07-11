module Publishable
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def publishable(scope_symbols = nil)
      class_name = self.class.name.undercase
      derived_names = "derived_#{class_name.pluralize}"
      source_name = "source_#{class_name}"
      source_name_id = "#{source_name}_id"

      class_eval do
        cattr_accessor :publish_scope_array
        publish_scope_array = scope_symbols.nil? ? nil : \
          (scope_symbols.is_a?(Array) ? scope_symbols : [scope_symbols])

        belongs_to source_name, :class_name => class_name

        has_many derived_names, :class_name => class_name, :foreign_key => source_name_id

        before_validation :assign_next_number, :on => :create

        validates_presence_of :number, :version
        validates_presence_of :license, :if => :published_at
        validates_uniqueness_of :version, :scope => ((publish_scope_array || []) << :number)

        default_scope order([:number, :version])

        def publish
          #TODO
          self.published_at = Time.now
          self.save
        end

        def new_version
          version_scope = publish_scope.where(:number => number)
          #TODO
        end

        def derive
          #TODO
        end

        protected

        def publish_scope
          publish_scope_array.nil? ? self.class.scoped : self.class.where(Hash[publish_scope_array.map{|s| [s, send(s)]}])
        end

        def assign_next_number
          self.number = ((publish_scope.maximum(:number) || -1) + 1) if number.nil?
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Publishable
