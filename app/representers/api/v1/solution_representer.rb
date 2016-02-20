module Api::V1
  class SolutionRepresenter < PublicationRepresenter

    has_logic
    has_attachments

    property :title,
             type: String,
             writeable: true,
             readable: true

    property :solution_type,
             type: String,
             writeable: true,
             readable: true

    property :content,
             as: :content_html,
             type: String,
             writeable: true,
             readable: true

    property :is_by_collaborator,
             type: 'boolean',
             readable: true,
             writeable: false

  end
end
