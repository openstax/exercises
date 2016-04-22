module Api::V1
  class VocabTermSearchRepresenter < OpenStax::Api::V1::AbstractSearchRepresenter

    collection :items, inherit: true,
                       class: VocabTerm,
                       decorator: VocabTermWithDistractorsAndExerciseIdsRepresenter

  end
end
