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
               decorator: ListNestingRepresenter,
               writeable: true,
               readable: true,
               parse_strategy: :sync

    collection :list_exercises,
               as: :exercises,
               class: ListExercise,
               decorator: ListExerciseRepresenter,
               writeable: true,
               readable: true,
               parse_strategy: :sync

    collection :list_owners,
               as: :owners,
               class: ListOwner,
               decorator: RoleRepresenter,
               writeable: true,
               readable: true,
               parse_strategy: :sync

    collection :list_editors,
               as: :editors,
               class: ListEditor,
               decorator: RoleRepresenter,
               writeable: true,
               readable: true,
               parse_strategy: :sync

    collection :list_readers,
               as: :readers,
               class: ListReader,
               decorator: RoleRepresenter,
               writeable: true,
               readable: true,
               parse_strategy: :sync

  end
end
