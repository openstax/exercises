module Api::V1
  class SimpleChoiceRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: false,
             schema_info: {
               required: true
             }
             
    property :content, 
             class: Content, 
             decorator: ContentRepresenter, 
             parse_strategy: :sync

    property :position, 
             type: Integer, 
             writeable: false

    property :credit,
             type: Float,
             writeable: true

  end
end
