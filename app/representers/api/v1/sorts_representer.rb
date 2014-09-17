module Api::V1
  class SortsRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :domain_id,
             type: Integer,
             readable: false,
             writeable: true

    property :domain_type,
             type: String,
             readable: false,
             writeable: true

    property :sortable_type,
             type: String,
             readable: false,
             writeable: true,
             schema_info: {
               required: true
             }

    collection :sorts,
               class: Sort,
               decorator: SortRepresenter,
               readable: false,
               writeable: true,
               parse_strategy: :sync,
               schema_info: {
                 required: true
               }

  end
end
