
# Representers for the sorting APIs.  Note that we only use these for 
# documentating the API.

module Api::V1

  class NewPositionRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             schema_info: {
               required: true
             }

    property :position,
             type: Integer,
             schema_info: {
                required: true
             }
  end

  class SortRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    collection :newPositions, 
               # class: Part, 
               decorator: NewPositionRepresenter, 
               schema_info: {
                 minItems: 0,
                 required: true
               }
  end
end
