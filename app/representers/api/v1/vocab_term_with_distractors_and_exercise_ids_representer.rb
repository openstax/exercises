module Api::V1
  class VocabTermWithDistractorsAndExerciseIdsRepresenter < VocabTermRepresenter

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

    collection :exercise_ids,
               type: Integer,
               writeable: false,
               readable: true,
               schema_info: {
                 required: true
               }

  end
end
