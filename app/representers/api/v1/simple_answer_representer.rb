module Api::V1
  class SimpleAnswerRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :id,
             type: Integer,
             writeable: true,
             readable: true,
             setter: lambda { |val| self.temp_id = val },
             schema_info: {
               required: true
             }

    property :question_id,
             type: Integer,
             writeable: false,
             readable: true

    property :content,
             as: :content_html,
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
             getter: lambda { |args| stem_answers.first.try(:correctness) },
             setter: lambda { |value, args|
              stem_answers << StemAnswer.new(answer: self,
                                             stem: question.stems.first) \
                unless stem_answers.exists?
              stem_answers.first.correctness = value },
             schema_info: {
               type: 'number'
             }

  end
end
