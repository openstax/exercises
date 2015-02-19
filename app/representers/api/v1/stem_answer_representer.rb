module Api::V1
  class StemAnswerRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :answer_id,
             type: Integer,
             writeable: true,
             readable: true,
             setter: lambda { |val|
               self.answer = question.answers.select{|i| (i.id || i.temp_id) == val}.first
             },
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

    property :feedback,
             as: :feedback_html,
             type: String,
             writeable: true,
             readable: true

  end
end
