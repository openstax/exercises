module Api::V1
  class ListPublicationGroupRepresenter < Roar::Decorator

    include Roar::JSON

    property :publishable_type,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

    property :uuid,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

    property :number,
             type: Integer,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

  end
end
