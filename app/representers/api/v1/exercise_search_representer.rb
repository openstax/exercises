module Api::V1
  class ExerciseSearchRepresenter < OpenStax::Api::V1::AbstractSearchRepresenter

    collection :items, inherit: true,
                       class: Exercise,
                       extend: ExerciseRepresenter

  end
end
