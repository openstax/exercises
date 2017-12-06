module Api::V1
  class ComboChoiceRepresenter < Roar::Decorator

    include Roar::JSON

    collection :combo_choice_answers,
               class: ComboChoiceAnswer,
               representer: ComboChoiceAnswerRepresenter,
               writeable: true,
               readable: true,
               setter: AR_COLLECTION_SETTER,
               schema_info: {
                 required: true
               }

    property :correctness,
             type: Float,
             writeable: true,
             readable: true,
             schema_info: {
               type: 'number'
             }

  end
end
