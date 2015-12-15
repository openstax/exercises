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

  module Roar
    module Decorator
      def stylable
        collection :formats,
                   type: String,
                   writeable: true,
                   readable: true,
                   getter: lambda { |args| stylings.collect{|s| s.style} },
                   setter: lambda { |val, args|
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

ActiveRecord::Base.send :include, Stylable::ActiveRecord::Base
Roar::Decorator.extend Stylable::Roar::Decorator
