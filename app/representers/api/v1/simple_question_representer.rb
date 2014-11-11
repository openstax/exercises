module Api::V1
  class SimpleQuestionRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: true,
             readable: true,
             setter: lambda { |val| self.temp_id = val }

    property :stimulus,
             type: String,
             writeable: true,
             readable: true

    property :stem,
             type: String,
             writeable: true,
             readable: true,
             getter: lambda { |*| stems.first.content },
             setter: lambda { |val|
               stems << Stem.new(question: self) unless stems.exists?
               stems.first.content = val },
             schema_info: {
               required: true
             }

    collection :answers,
               class: Answer,
               decorator: SimpleAnswerRepresenter,
               writeable: true,
               readable: true,
               schema_info: {
                 required: true
               }

    collection :combo_choices,
               class: ComboChoice,
               decorator: ComboChoiceRepresenter,
               writeable: true,
               readable: true,
               getter: lambda { |*| stems.first.try(:combo_choices) },
               instance: lambda { |val| stems.find_or_instantiate_by(
                                          :answer_id, val) }

  end
end
