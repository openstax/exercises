module Api::V1::Exercises
  class ComboChoiceRepresenter < BaseRepresenter

    collection :combo_choice_answers,
               class: ComboChoiceAnswer,
               representer: ComboChoiceAnswerRepresenter,
               writeable: true,
               readable: true,
               setter: AR_COLLECTION_SETTER,
               schema_info: {
                 required: true
               },
               if: CACHED_PUBLIC_FIELDS

    property :correctness,
             type: Float,
             writeable: true,
             readable: true,
             schema_info: {
               type: 'number'
             },
             if: CACHED_PRIVATE_FIELDS

  end
end
