module Api::V1
  class VocabTermRepresenter < Roar::Decorator

    include Roar::JSON

    has_tags

    publishable

    property :name,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

    property :definition,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

  end
end
