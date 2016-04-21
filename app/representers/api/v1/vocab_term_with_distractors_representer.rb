module Api::V1
  class VocabTermWithDistractorsRepresenter < VocabTermRepresenter

    collection :distractor_terms,
               class: VocabTerm,
               decorator: VocabTermRepresenter,
               writeable: true,
               readable: true,
               schema_info: {
                 required: true
               }

    collection :distractor_literals,
               type: String,
               writeable: true,
               readable: true,
               schema_info: {
                 required: true
               }

  end
end
