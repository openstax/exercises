module Api::V1
  class AnswerRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: false,
             readable: true

    property :content,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

    property :correctness,
             type: Float,
             writeable: true,
             readable: true,
             schema_info: {
               type: 'number'
             }

  end
end
