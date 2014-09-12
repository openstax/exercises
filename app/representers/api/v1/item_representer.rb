module Api::V1
  class ItemRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id,
             writeable: false,
             readable: true

    property :content,
             type: String,
             writeable: true,
             readable: true

    collection :answers,
               class: Answer,
               decorator: AnswerRepresenter,
               parse_strategy: :sync,
               writeable: true,
               readable: true,
               schema_info: {
                 required: true
               }

    collection :combo_choices,
               class: ComboChoice,
               decorator: ComboChoiceRepresenter,
               parse_strategy: :sync,
               writeable: true,
               readable: true

  end
end
