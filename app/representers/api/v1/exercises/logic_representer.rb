module Api::V1::Exercises
  class LogicRepresenter < BaseRepresenter

    property :id,
             type: Integer,
             readable: true,
             writeable: false,
             schema_info: {
               required: true
             }

    property :language,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

    property :code,
             type: String,
             readable: true,
             writeable: true,
             schema_info: {
               required: true
             }

    collection :logic_variables,
               class: LogicVariable,
               extend: LogicVariableRepresenter,
               readable: true,
               writeable: true,
               setter: AR_COLLECTION_SETTER,
               schema_info: {
                 required: true,
                 description: "The variables used in this Logic"
               }

  end
end
