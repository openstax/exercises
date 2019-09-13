module Api::V1::Exercises
  class StemRepresenter < BaseRepresenter

    stylable(if: CACHED_PUBLIC_FIELDS)

    property :content,
             as: :content_html,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             },
             if: CACHED_PUBLIC_FIELDS

    collection :stem_answers,
               class: StemAnswer,
               extend: StemAnswerRepresenter,
               writeable: true,
               readable: true,
               setter: AR_COLLECTION_SETTER

    collection :combo_choices,
               class: ComboChoice,
               extend: ComboChoiceRepresenter,
               writeable: true,
               readable: true,
               setter: AR_COLLECTION_SETTER

  end
end
