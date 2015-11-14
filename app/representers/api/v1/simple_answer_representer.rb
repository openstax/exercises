module Api::V1
  class SimpleAnswerRepresenter < Roar::Decorator

    include Roar::JSON

    property :id,
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
             if: lambda { |args| question.exercise.can_view_solutions?(args[:user]) },
             getter: lambda { |args| stem_answers.first.try(:correctness) },
             setter: lambda { |value, args|
              stem_answers << StemAnswer.new(answer: self,
                                             stem: question.stems.first) \
                if stem_answers.empty?
              stem_answers.first.correctness = value
             },
             schema_info: {
               type: 'number'
             }

    property :feedback,
             as: :feedback_html,
             type: String,
             writeable: true,
             readable: true,
             if: lambda { |args| question.exercise.can_view_solutions?(args[:user]) },
             getter: lambda { |args| stem_answers.first.try(:feedback) },
             setter: lambda { |value, args|
              stem_answers << StemAnswer.new(answer: self,
                                             stem: question.stems.first) \
                if stem_answers.empty?
              stem_answers.first.feedback = value
             }

  end
end
