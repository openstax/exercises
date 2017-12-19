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
        collection :stylings,
                   as: :formats,
                   type: String,
                   readable: true,
                   serialize: ->(input:, **) { input.style },
                   writeable: true,
                   class: Styling,
                   deserialize: ->(input:, fragment:, **) do
                     input.tap { |input| input.style = fragment }
                   end,
                   setter: AR_COLLECTION_SETTER,
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
