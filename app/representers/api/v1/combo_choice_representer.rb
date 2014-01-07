module Api::V1
  class ComboChoiceRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: false,
             schema_info: {
               required: true
             }

    property :credit,
             type: Float,
             writeable: true
    
    collection :combo_simple_choices, 
               class: ComboSimpleChoice, 
               decorator: ComboSimpleChoiceRepresenter, 
               parse_strategy: :sync,
               schema_info: {
                 minItems: 0
               }

  end
end
