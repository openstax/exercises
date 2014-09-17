module Api::V1
  class ExerciseRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    publishable
    has_logic
    has_attachments

    property :id, 
             type: Integer,
             writeable: false,
             readable: true

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
               writeable: true,
               readable: true,
               parse_strategy: :sync,
               schema_info: {
                 required: true
               }

  end
end
