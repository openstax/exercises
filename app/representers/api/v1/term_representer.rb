module Api::V1
  class TermRepresenter < Roar::Decorator

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

    property :description,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

  end
end
