module Api::V1
  class ComboChoiceAnswerRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :answer_id, 
             type: Integer,
             writeable: true,
             readable: true,
             setter: lambda { |val|
               self.answer = question.answers.select{|i| (i.id || i.temp_id) == val}.first
             },
             schema_info: {
               required: true
             }

  end
end
