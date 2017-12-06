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
               readable: true,
               setter: AR_COLLECTION_SETTER

    collection :list_publication_groups,
               as: :publication_groups,
               class: ListPublicationGroup,
               extend: ListPublicationGroupRepresenter,
               writeable: true,
               readable: true,
               setter: AR_COLLECTION_SETTER

    collection :list_owners,
               as: :owners,
               class: ListOwner,
               extend: RoleRepresenter,
               writeable: true,
               readable: true,
               setter: AR_COLLECTION_SETTER

    collection :list_editors,
               as: :editors,
               class: ListEditor,
               extend: RoleRepresenter,
               writeable: true,
               readable: true,
               setter: AR_COLLECTION_SETTER

    collection :list_readers,
               as: :readers,
               class: ListReader,
               extend: RoleRepresenter,
               writeable: true,
               readable: true,
               setter: AR_COLLECTION_SETTER

  end
end
