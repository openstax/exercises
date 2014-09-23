module Api::V1
  class LogicRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             readable: true,
             writeable: false,
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

    collection :logic_libraries,
               as: :libraries,
               class: LogicLibrary,
               decorator: LogicLibraryRepresenter,
               readable: true,
               writeable: true,
               parse_strategy: :sync,
               schema_info: {
                 required: true,
                 description: "The code libraries used by this Logic," +
                   "listed in the order the code should be read/included before" +
                   "the code in this Logic is read/included"
               }

    collection :logic_variables,
               class: LogicVariable,
               decorator: LogicVariableRepresenter,
               readable: true,
               writeable: true,
               parse_strategy: :sync,
               schema_info: {
                 required: true,
                 description: "The variables used in this Logic"
               }

  end
end
