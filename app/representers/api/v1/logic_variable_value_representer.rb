module Api::V1
  class LogicVariableValueRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :seed,
             type: Integer,
             readable: true,
             writeable: true,
             schema_info: {
               required: true
             }

    property :value,
             type: String,
             readable: true,
             writeable: true,
             schema_info: {
               required: true
             }

  end
end
