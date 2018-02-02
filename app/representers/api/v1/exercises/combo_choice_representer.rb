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
               if: NOT_SOLUTIONS_ONLY

    property :correctness,
             type: Float,
             writeable: true,
             readable: true,
             schema_info: {
               type: 'number'
             },
             if: SOLUTIONS

  end
end
