module Api::V1::Exercises
  class SimpleAnswerRepresenter < BaseRepresenter

    property :id,
             type: Integer,
             writeable: false,
             readable: true,
             if: CACHED_PUBLIC_FIELDS

    property :content,
             as: :content_html,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             },
             if: CACHED_PUBLIC_FIELDS

    property :correctness,
             type: Float,
             writeable: true,
             readable: true,
             getter: ->(*) do
              stem_answers << StemAnswer.new(answer: self, stem: question.stems.first) \
                if stem_answers.empty?

               stem_answers.first.correctness
             end,
             setter: ->(options) do
              stem_answers << StemAnswer.new(answer: self, stem: question.stems.first) \
                if stem_answers.empty?

              stem_answers.first.correctness = options[:input]
             end,
             schema_info: {
               type: 'number'
             },
             if: CACHED_PRIVATE_FIELDS

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
             setter: ->(options) do
               stem_answers << StemAnswer.new(answer: self, stem: question.stems.first) \
                 if stem_answers.empty?

               stem_answers.first.feedback = options[:input]
             end,
             if: CACHED_PRIVATE_FIELDS

  end
end
