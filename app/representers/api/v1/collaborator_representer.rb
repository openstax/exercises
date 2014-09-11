module Api::V1
  class CollaboratorRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :user,
             class: Collaborator,
             decorator: CollaboratorRepresenter,
             parse_strategy: :sync,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

  end
end
