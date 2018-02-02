module Api::V1::Exercises
  class SimpleAnswerRepresenter < BaseRepresenter

    property :id,
             type: Integer,
             writeable: false,
             readable: true,
             if: NOT_SOLUTIONS_ONLY

    property :content,
             as: :content_html,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             },
             if: NOT_SOLUTIONS_ONLY

    property :correctness,
             type: Float,
             writeable: true,
             readable: true,
             getter: ->(*) do
              stem_answers << StemAnswer.new(answer: self, stem: question.stems.first) \
                if stem_answers.empty?

               stem_answers.first.correctness
             end,
             setter: ->(input:, **) do
              stem_answers << StemAnswer.new(answer: self, stem: question.stems.first) \
                if stem_answers.empty?

              stem_answers.first.correctness = input
             end,
             schema_info: {
               type: 'number'
             },
             if: SOLUTIONS

    property :feedback,
             as: :feedback_html,
             type: String,
             writeable: true,
             readable: true,
             getter: ->(*) do
               stem_answers << StemAnswer.new(answer: self, stem: question.stems.first) \
                 if stem_answers.empty?

               stem_answers.first.feedback
             end,
             setter: ->(input:, **) do
               stem_answers << StemAnswer.new(answer: self, stem: question.stems.first) \
                 if stem_answers.empty?

               stem_answers.first.feedback = input
             end,
             if: SOLUTIONS

  end
end
