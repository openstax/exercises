module Api::V1
  class QuestionRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: true,
             readable: true,
             setter: lambda { |val| self.temp_id = val }

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
               writeable: true,
               readable: true,
               schema_info: {
                 required: true
               }

    collection :answers,
               class: Answer,
               decorator: AnswerRepresenter,
               writeable: true,
               readable: true,
               schema_info: {
                 required: true
               }

    collection :combo_choices,
               class: ComboChoice,
               decorator: ComboChoiceRepresenter,
               writeable: true,
               readable: true

    collection :stylings,
               as: :styles,
               class: Styling,
               decorator: StylingRepresenter,
               writeable: true,
               readable: true,
               schema_info: {
                 required: true
               }

    collection :parent_dependencies,
               as: :dependencies,
               class: QuestionDependency,
               decorator: QuestionDependencyRepresenter,
               writeable: true,
               readable: true,
               schema_info: {
                 required: true
               }

  end
end
