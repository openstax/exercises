module Api::V1
  class ComboChoiceAnswerRepresenter < Roar::Decorator

    include Roar::JSON

    property :answer_id,
             type: Integer,
             writeable: true,
             readable: true,
             setter: ->(input:, **) do
               self.answer = question.answers.find{ |ans| (ans.id || ans.temp_id) == input }
             end,
             schema_info: {
               required: true
             }

  end
end
