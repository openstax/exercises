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
      def stylable(options = {})
        collection :stylings,
                   {
                     as: :formats,
                     type: String,
                     readable: true,
                     serialize: ->(options) { options[:input].style },
                     writeable: true,
                     class: Styling,
                     deserialize: ->(options) do
                       options[:input].tap { |input| input.style = options[:fragment] }
                     end,
                     setter: AR_COLLECTION_SETTER,
                     schema_info: {
                       required: true,
                       description: 'The question formats allowed for this object'
                     }
                   }.merge(options)
      end
    end
  end
end

ActiveRecord::Base.extend Stylable::ActiveRecord::Base
Roar::Decorator.extend Stylable::Roar::Decorator
