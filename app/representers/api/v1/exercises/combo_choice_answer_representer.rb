module Api::V1::Exercises
  class ComboChoiceAnswerRepresenter < BaseRepresenter

    property :answer_id,
             type: Integer,
             writeable: true,
             readable: true,
             setter: ->(input:, **) do
               self.answer = question.answers.find { |ans| (ans.id || ans.temp_id) == input }
             end,
             schema_info: {
               required: true
             }

  end
end
