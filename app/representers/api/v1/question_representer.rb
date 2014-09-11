module Api::V1
  class QuestionRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id,
             writeable: false,
             readable: true

    property :stem,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

    collection :items,
               class: Item,
               decorator: ItemRepresenter,
               parse_strategy: :sync,
               writeable: true,
               readable: true,
               schema_info: {
                 minItems: 1
               }

  end
end
