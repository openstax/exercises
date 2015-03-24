module Api::V1
  class ListNestingRepresenter < Roar::Decorator

    include Roar::JSON

    property :list_id,
             type: Integer,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

  end
end
