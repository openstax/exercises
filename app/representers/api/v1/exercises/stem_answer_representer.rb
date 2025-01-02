module Api::V1::Exercises
  class StemAnswerRepresenter < BaseRepresenter

    property :answer_id,
             type: Integer,
             writeable: true,
             readable: true,
             setter: ->(options) do
               self.answer = question.answers.find { |ans| (ans.id || ans.temp_id) == options[:input] }
             end,
             schema_info: {
               required: true
             },
             if: CACHED_PUBLIC_FIELDS

    property :correctness,
             type: Float,
             writeable: true,
             readable: true,
             schema_info: {
               type: 'number'
             },
             if: CACHED_PRIVATE_FIELDS

    property :feedback,
             as: :feedback_html,
             type: String,
             writeable: true,
             readable: true,
             if: CACHED_PRIVATE_FIELDS

  end
end
