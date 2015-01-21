module Api::V1
  class SimpleAnswerRepresenter < Roar::Decorator

    include Roar::Representer::JSON

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
             getter: lambda { |args| stem_answers.first.try(:content) },
             setter: lambda { |value, args|
              stem_answers << StemAnswer.new(answer: self,
                                             stem: question.stems.first) \
                if stem_answers.empty?
              stem_answers.first.content = value },
             schema_info: {
               type: 'number'
             }

  end
end
