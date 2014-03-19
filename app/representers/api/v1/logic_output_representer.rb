module Api::V1
  class LogicOutputRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: false,
             schema_info: {
               required: true
             }

    property :seed,
             type: Integer,
             writeable: true,
             schema_info: {
               required: true
             }

    property :values,
             type: String,
             writeable: true,
             schema_info: {
               required: true
             }

  end
end
