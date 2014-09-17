module Api::V1
  class SortRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :sortable_id,
             type: Integer,
             readable: false,
             writeable: true,
             schema_info: {
               required: true
             }

  end
end
