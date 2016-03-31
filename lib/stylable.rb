module Stylable
  module ActiveRecord
    module Base
      def stylable
        class_exec do
          has_many :stylings, as: :stylable, dependent: :destroy
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
                   setter: lambda { |styles, args|
                     [styles].flatten.each do |style|
                       # This adds the new styling to stylings if not there
                       stylings.find_or_initialize_by(style: style, stylable: self)
                     end
                   },
                   schema_info: {
                     required: true,
                     description: 'The formats allowed for this object'
                   }
      end
    end
  end
end

ActiveRecord::Base.extend Stylable::ActiveRecord::Base
Roar::Decorator.extend Stylable::Roar::Decorator
