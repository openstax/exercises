module Api::V1
  class ComboChoiceAnswerRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: false,
             readable: true

    property :combo_choice,
             class: ComboChoice,
             representer: ComboChoiceRepresenter,
             writeable: true,
             readable: false

    property :answer,
             type: Answer,
             representer: AnswerRepresenter,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

  end
end
