module Api::V1
  class ComboSimpleChoiceRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: false,
             schema_info: {
               required: true
             }

    property :simple_choice_id,
             type: Integer,
             writeable: true,
             schema_info: {
               required: true
             }

    property :combo_choice_id,
             type: Integer,
             writeable: true,
             schema_info: {
               required: true
             }
  end
end
