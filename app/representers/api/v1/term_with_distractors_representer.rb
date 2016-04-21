module Api::V1
  class TermWithDistractorsRepresenter < TermRepresenter

    collection :distractor_terms,
               class: Term,
               decorator: TermRepresenter,
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
