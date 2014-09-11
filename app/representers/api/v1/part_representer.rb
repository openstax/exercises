module Api::V1
  class PartRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id,
             writeable: false

    property :background,
             type: String

    collection :questions,
               class: Question,
               decorator: QuestionRepresenter,
               parse_strategy: :sync,
               schema_info: {
                 minItems: 1
               }

  end
end
