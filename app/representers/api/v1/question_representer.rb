module Api::V1
  class QuestionRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id,
             writeable: false

    property :stem,
             type: String

    collection :items,
               class: Item,
               decorator: ItemRepresenter,
               parse_strategy: :sync,
               schema_info: {
                 minItems: 1
               }

  end
end
