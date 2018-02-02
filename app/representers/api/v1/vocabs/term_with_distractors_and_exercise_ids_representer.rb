module Api::V1::Vocabs
  class TermWithDistractorsAndExerciseIdsRepresenter < TermRepresenter

    property :name,
             inherit: true,
             writeable: true

    property :definition,
             inherit: true,
             writeable: true

    collection :vocab_distractors,
               as: :distractor_terms,
               class: VocabDistractor,
               extend: DistractorRepresenter,
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

    def to_hash(*)
      Rails.cache.fetch("#{represented.cache_key}/with_distractors_and_exercise_ids") { super }
    end

    protected

    def latest_exercises
      @latest_exercises ||= represented.latest_exercises
    end

  end
end
