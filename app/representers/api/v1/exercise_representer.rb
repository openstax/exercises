module Api::V1
  class ExerciseRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    publishable
    has_logic
    has_attachments

    property :title,
             type: String,
             writeable: true,
             readable: true

    property :background,
             type: String,
             writeable: true,
             readable: true

    collection :parts,
               class: Part,
               decorator: PartRepresenter,
               parse_strategy: :sync,
               writeable: true,
               readable: true,
               schema_info: {
                 required: true
               }

  end
end
