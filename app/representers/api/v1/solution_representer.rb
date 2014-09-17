module Api::V1
  class SolutionRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    publishable
    has_logic
    has_attachments

    property :title,
             type: String,
             writeable: true,
             readable: true

    property :summary,
             type: String,
             writeable: true,
             readable: true

    property :details,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

  end
end
