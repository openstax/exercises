module Api::V1
  class ComboChoiceAnswerRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: false,
             schema_info: {
               required: true
             }

    property :combo_choice,
             class: ComboChoice,
             representer: ComboChoiceRepresenter,
             writeable: true,
             schema_info: {
               required: true
             }

    property :answer,
             type: Answer,
             representer: AnswerRepresenter,
             writeable: true,
             schema_info: {
               required: true
             }

  end
end
