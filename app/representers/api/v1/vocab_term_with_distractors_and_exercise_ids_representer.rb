module Api::V1
  class VocabTermWithDistractorsAndExerciseIdsRepresenter < VocabTermRepresenter

    property :name,
             inherit: true,
             writeable: true

    property :definition,
             inherit: true,
             writeable: true

    collection :vocab_distractors,
               as: :distractor_terms,
               class: VocabDistractor,
               extend: VocabDistractorRepresenter,
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

    collection :latest_exercise_uids,
               as: :exercise_uids,
               type: String,
               writeable: false,
               readable: true,
               schema_info: {
                 required: true
               }

  end
end
