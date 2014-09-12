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
               parse_strategy: :sync,
               writeable: true,
               readable: true,
               schema_info: {
                 required: true
               }

    collection :answers,
               class: Answer,
               decorator: AnswerRepresenter,
               parse_strategy: :sync,
               writeable: true,
               readable: true,
               schema_info: {
                 required: true
               }

    collection :combo_choices,
               class: ComboChoice,
               decorator: ComboChoiceRepresenter,
               parse_strategy: :sync,
               writeable: true,
               readable: true

    collection :formattings,
               as: :formats,
               class: Formatting,
               decorator: FormattingRepresenter,
               parse_strategy: :sync,
               writeable: true,
               readable: true,
               schema_info: {
                 required: true
               }

    collection :parent_dependencies,
               as: :dependencies,
               class: QuestionDependency,
               decorator: QuestionDependencyRepresenter,
               parse_strategy: :sync,
               writeable: true,
               readable: true,
               schema_info: {
                 required: true
               }

  end
end
