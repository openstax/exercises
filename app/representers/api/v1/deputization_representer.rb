module Api::V1
  class DeputizationRepresenter < Roar::Decorator

    include Roar::JSON

    property :deputy_type,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

    property :deputy_id,
             type: Integer,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

  end
end
