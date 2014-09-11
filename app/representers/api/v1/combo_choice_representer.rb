module Api::V1
  class ComboChoiceRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: false,
             readable: true

    property :correctness,
             type: Float,
             writeable: true,
             readable: true,
             schema_info: {
               type: 'number'
             }

    collection :combo_choice_answers,
               class: ComboChoiceAnswer,
               representer: ComboChoiceAnswerRepresenter,
               writeable: true,
               readable: true,
               schema_info: {
                 minItems: 1
               }

  end
end
