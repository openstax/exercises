module Api::V1
  class AnswerRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: false,
             schema_info: {
               required: true
             }
             
    property :content,
             type: String

    property :correctness,
             type: Float

  end
end
