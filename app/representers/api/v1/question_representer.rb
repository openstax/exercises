module Api::V1
  class QuestionRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: true,
             readable: true,
             setter: lambda { |val, *| self.temp_id = val }

    property :stimulus,
             as: :stimulus_html,
             type: String,
             writeable: true,
             readable: true

    collection :stems,
               class: Stem,
               decorator: StemRepresenter,
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

    collection :hints,
               type: String,
               writeable: true,
               readable: true,
               getter: lambda { |*| hints.collect{|h| h.content} },
               setter: lambda { |val|
                 hint = hints.find_or_initialize_by(content: val)
                 hints << hint unless hint.persisted?
               },
               schema_info: {
                 required: true,
                 description: 'Author-supplied hints for the question'
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
