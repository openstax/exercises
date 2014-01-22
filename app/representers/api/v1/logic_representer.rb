module Api::V1
  class LogicRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: false,
             schema_info: {
               required: true
             }

    property :code,
             type: String,
             writeable: true,
             schema_info: {
               required: true
             }

    property :variables,
             type: String,
             writeable: true,
             schema_info: {
               required: true
             }

    collection :logic_outputs, 
               class: LogicOutput, 
               decorator: LogicOutputRepresenter, 
               parse_strategy: :sync,
               schema_info: {
                 minItems: 0
               }

  end
end
