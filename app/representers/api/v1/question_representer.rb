module Api::V1
  class QuestionRepresenter < Roar::Decorator

    include Roar::JSON

    can_view_solutions_proc = ->(user_options:, **) do
      user_options[:can_view_solutions] ||=
        user_options.has_key?(:can_view_solutions) ?
          user_options[:can_view_solutions] :
          exercise.can_view_solutions?(user_options[:user])
    end

    property :id,
             type: Integer,
             writeable: true,
             readable: true,
             setter: ->(input:, **) { self.temp_id = input }

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
               extend: StemRepresenter,
               writeable: true,
               readable: true,
               schema_info: {
                 required: true
               }

    collection :answers,
               instance: ->(*) { Answer.new(question: self) },
               extend: AnswerRepresenter,
               writeable: true,
               readable: true,
               schema_info: {
                 required: true
               }

    collection :collaborator_solutions,
               class: CollaboratorSolution,
               extend: CollaboratorSolutionRepresenter,
               writeable: true,
               readable: true,
               if: can_view_solutions_proc

    collection :community_solutions,
               class: CommunitySolution,
               extend: CommunitySolutionRepresenter,
               writeable: false,
               readable: true,
               if: can_view_solutions_proc

    collection :hints,
               type: String,
               writeable: true,
               readable: true,
               getter: ->(*) { hints.map(&:content) },
               setter: ->(input:, **) do
                 input.each do |val|
                   hint = hints.find_or_initialize_by(content: val)
                   hints << hint unless hint.persisted?
                 end
               end,
               schema_info: {
                 required: true,
                 description: 'Author-supplied hints for the question'
               }

    collection :parent_dependencies,
               as: :dependencies,
               class: QuestionDependency,
               extend: QuestionDependencyRepresenter,
               writeable: true,
               readable: true,
               schema_info: {
                 required: true
               }

  end
end
