module Api::V1
  class StemRepresenter < Roar::Decorator

    include Roar::JSON

    stylable

    property :content,
             as: :content_html,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

    collection :stem_answers,
               class: StemAnswer,
               decorator: StemAnswerRepresenter,
               instance: lambda { |*| StemAnswer.new(stem: self) },
               writeable: true,
               readable: true

    collection :combo_choices,
               class: ComboChoice,
               decorator: ComboChoiceRepresenter,
               writeable: true,
               readable: true

  end
end
