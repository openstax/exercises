module Api::V1
  class PartRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id,
             writeable: false,
             readable: true

    property :background,
             type: String,
             writeable: true,
             readable: true

    collection :questions,
               class: Question,
               decorator: QuestionRepresenter,
               parse_strategy: :sync,
               writeable: true,
               readable: true,
               schema_info: {
                 required: true
               }

  end
end
