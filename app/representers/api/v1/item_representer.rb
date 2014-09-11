module Api::V1
  class ItemRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id,
             writeable: false

    property :content,
             type: String

    collection :answers,
               class: Answer,
               decorator: AnswerRepresenter,
               parse_strategy: :sync,
               schema_info: {
                 minItems: 1
               }

    collection :combo_choices,
               class: ComboChoice,
               decorator: ComboChoiceRepresenter,
               parse_strategy: :sync,
               schema_info: {
                 minItems: 0
               }

  end
end
