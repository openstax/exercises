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
               setter: AR_COLLECTION_SETTER,
               schema_info: {
                 required: true
               }

    collection :distractor_literals,
               type: String,
               writeable: true,
               readable: true,
               setter: AR_COLLECTION_SETTER,
               schema_info: {
                 required: true
               }

    collection :exercise_uuids,
               type: String,
               writeable: false,
               readable: true,
               getter: ->(*) { latest_exercises.map(&:uuid) },
               exec_context: :decorator,
               schema_info: {
                 required: true
               }

    collection :exercise_uids,
               type: String,
               writeable: false,
               readable: true,
               getter: ->(*) { latest_exercises.map(&:uid) },
               exec_context: :decorator,
               schema_info: {
                 required: true
               }

    protected

    def latest_exercises
      @latest_exercises ||= represented.latest_exercises
    end

  end
end
