module Api::V1
  class ListRepresenter < Roar::Decorator

    include Roar::JSON

    publishable

    property :parent_list_uid,
             type: Integer,
             writeable: false,
             readable: true

    collection :list_nestings,
               as: :nestings,
               class: ListNesting,
               extend: ListNestingRepresenter,
               writeable: true,
               readable: true

    collection :list_exercises,
               as: :exercises,
               class: ListExercise,
               extend: ListExerciseRepresenter,
               writeable: true,
               readable: true

    collection :list_owners,
               as: :owners,
               class: ListOwner,
               extend: RoleRepresenter,
               writeable: true,
               readable: true

    collection :list_editors,
               as: :editors,
               class: ListEditor,
               extend: RoleRepresenter,
               writeable: true,
               readable: true

    collection :list_readers,
               as: :readers,
               class: ListReader,
               extend: RoleRepresenter,
               writeable: true,
               readable: true

  end
end
