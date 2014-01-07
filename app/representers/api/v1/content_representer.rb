module Api::V1
  class ContentRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: false,
             schema_info: {
               required: true
             }
             

    property :markup, 
             type: String

    property :html, 
             type: String, 
             writeable: false

  end
end
