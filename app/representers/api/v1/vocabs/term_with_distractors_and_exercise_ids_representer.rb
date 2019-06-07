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

    def self.cache_key_types_for(represented, options = {})
      [ 'with_distractors_and_exercise_ids' ]
    end

    def self.cache_key_for(represented, type)
        "#{represented.cache_key}/#{represented.cache_version}/#{type}"
    end

    def self.all_cache_keys_for(represented, options = {})
      cache_key_types_for(represented, options).map { |type| cache_key_for represented, type }
    end

    def self.all_cache_keys_for_array(represented_array, options = {})
      represented_array.flat_map { |represented| all_cache_keys_for represented, options }
    end

    def to_hash(*)
      Rails.cache.fetch(
        self.class.cache_key_for(represented, 'with_distractors_and_exercise_ids'),
        expires_in: NEVER_EXPIRES
      ) { super }
    end

    protected

    def latest_exercises
      @latest_exercises ||= represented.latest_exercises
    end

  end
end
