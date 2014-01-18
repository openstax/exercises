module Api::V1
  class LogicRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: false,
             schema_info: {
               required: true
             }

    property :logicable_type,
             type: String,
             writeable: true,
             schema_info: {
               required: true,
               description: "The name of the model to which this Logic belongs"
             }

    property :logicable_id,
             type: Integer,
             writeable: true,
             schema_info: {
               required: true,
               description: "The ID of the model to which this Logic belongs"
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

  end
end
