module Api::V1
  class SimpleQuestionRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: true,
             readable: true,
             setter: lambda { |val| self.temp_id = val }

    property :stimulus,
             type: String,
             writeable: true,
             readable: true

    collection :stylings,
               as: :formats,
               class: Styling,
               decorator: StylingRepresenter,
               writeable: true,
               readable: true,
               schema_info: {
                 required: true
               }

    property :stem,
             class: Stem,
             decorator: SimpleStemRepresenter,
             writeable: true,
             readable: true,
             getter: lambda { |*| stems.first },
             setter: lambda { |val| stems.first = val },
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
