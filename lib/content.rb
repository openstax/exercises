require 'ose_markup'

module Content
  module ActiveRecord
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def content(names = 'content')
        names_array = names.is_a?(Array) ? names.collect{|name| name.to_s} : [names.to_s]

        class_eval do
          names_array.each do |name|
            belongs_to name, class_name: 'Content', dependent: :destroy

            accepts_nested_attributes_for name

            validates_presence_of :content

            before_validation 
          end
        end
      end
    end
  end

  module TableDefinition
    def content(names = 'content')
      names_array = names.is_a?(Array) ? names.collect{|name| name.to_s} : [names.to_s]

      names_array.each do |name|
        references name
      end
    end
  end
end

ActiveRecord::Base.send :include, Content::ActiveRecord
ActiveRecord::ConnectionAdapters::TableDefinition.send :include, Content::TableDefinition
