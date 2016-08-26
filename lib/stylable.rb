module Stylable
  module ActiveRecord
    module Base
      def stylable
        class_exec do
          has_many :stylings, as: :stylable, dependent: :destroy, inverse_of: :stylable
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
                   getter: ->(*) { stylings.map(&:style) },
                   setter: ->(input:, **) do
                     styling = stylings.find_or_initialize_by(style: input)
                     stylings << styling unless styling.persisted?
                   end,
                   schema_info: {
                     required: true,
                     description: 'The question formats allowed for this object'
                   }
      end
    end
  end
end

ActiveRecord::Base.extend Stylable::ActiveRecord::Base
Roar::Decorator.extend Stylable::Roar::Decorator
