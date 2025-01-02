module Api::V1::Exercises
  class ComboChoiceAnswerRepresenter < BaseRepresenter

    property :answer_id,
             type: Integer,
             writeable: true,
             readable: true,
             setter: ->(options) do
               self.answer = question.answers.find { |ans| (ans.id || ans.temp_id) == options[:input] }
             end,
             schema_info: {
               required: true
             }

  end
end
