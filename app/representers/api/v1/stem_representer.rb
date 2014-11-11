module Api::V1
  class StemRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :content,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

    collection :stem_answers,
               class: StemAnswer,
               decorator: StemAnswerRepresenter,
               writeable: true,
               readable: true

  end
end
