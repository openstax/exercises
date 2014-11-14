module Stylable
  module ActiveRecord
    module Base
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        def stylable
          class_exec do
            has_many :stylings, as: :stylable, dependent: :destroy
          end
        end
      end
    end
  end

  module Representable
    module Declarative
      def stylable(method = :stylings)
        class_exec do
          collection :formats,
                     type: String,
                     writeable: true,
                     readable: true,
                     getter: lambda { |*| stylings.collect{|s| s.style} },
                     setter: lambda { |val|
                       styling = stylings.find_or_initialize_by(style: val)
                       stylings << styling unless styling.persisted?
                     },
                     schema_info: {
                       required: true,
                       description: 'The formats allowed for this object'
                     }
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Stylable::ActiveRecord::Base
Representable::Declarative.send :include, Stylable::Representable::Declarative
