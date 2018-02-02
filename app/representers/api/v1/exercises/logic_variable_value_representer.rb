module Api::V1::Exercises
  class LogicVariableValueRepresenter < BaseRepresenter

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
