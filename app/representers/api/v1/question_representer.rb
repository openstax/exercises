module Api::V1
  class QuestionRepresenter < Roar::Decorator

    include Roar::JSON

    property :id,
             type: Integer,
             writeable: true,
             readable: true,
             setter: lambda { |value, args| self.temp_id = value }

    property :answer_order_matters,
             as: :is_answer_order_important,
             writeable: true,
             readable: true,
             schema_info: {
               type: 'boolean'
             }

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

    collection :collaborator_solutions,
               class: CollaboratorSolution,
               decorator: CollaboratorSolutionRepresenter,
               writeable: true,
               readable: true,
               if: lambda { |args| exercise.can_view_solutions?(args[:user]) },
               schema_info: {
                 required: true
               }

    collection :community_solutions,
               class: CommunitySolution,
               decorator: CommunitySolutionRepresenter,
               writeable: false,
               readable: true,
               if: lambda { |args| exercise.can_view_solutions?(args[:user]) },
               schema_info: {
                 required: true
               }

    collection :hints,
               type: String,
               writeable: true,
               readable: true,
               getter: lambda { |args| hints.collect{ |h| h.content } },
               setter: lambda { |values, args|
                 values.each do |v|
                   hint = hints.find_or_initialize_by(content: v)
                   hints << hint unless hint.persisted?
                 end
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
