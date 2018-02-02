module Api::V1::Vocabs
  class TermRepresenter < Roar::Decorator

    include Roar::JSON

    has_tags

    publishable

    property :name,
             as: :term,
             type: String,
             readable: true,
             writeable: true,
             schema_info: {
               required: true
             }

    property :definition,
             type: String,
             readable: true,
             writeable: true,
             schema_info: {
               required: true
             }

  end
end
