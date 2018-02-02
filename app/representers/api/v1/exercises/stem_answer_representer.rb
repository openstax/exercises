module Api::V1::Exercises
  class StemAnswerRepresenter < BaseRepresenter

    property :answer_id,
             type: Integer,
             writeable: true,
             readable: true,
             setter: ->(input:, **) do
               self.answer = question.answers.find { |ans| (ans.id || ans.temp_id) == input }
             end,
             schema_info: {
               required: true
             },
             if: NOT_SOLUTIONS_ONLY

    property :correctness,
             type: Float,
             writeable: true,
             readable: true,
             schema_info: {
               type: 'number'
             },
             if: SOLUTIONS

    property :feedback,
             as: :feedback_html,
             type: String,
             writeable: true,
             readable: true,
             if: SOLUTIONS

  end
end
