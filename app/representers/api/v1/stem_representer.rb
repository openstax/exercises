module Api::V1
  class StemRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :id,
             type: Integer,
             writeable: true,
             readable: true,
             setter: lambda { |val| self.temp_id = val }

    property :content,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

    collection :stem_answers,
               class: StemAnswer,
               decorator: StemAnswerRepresenter,
               writeable: true,
               readable: true

    collection :combo_choices,
               class: ComboChoice,
               decorator: ComboChoiceRepresenter,
               writeable: true,
               readable: true

  end
end
