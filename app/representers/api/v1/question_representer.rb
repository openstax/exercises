module Api::V1
  class QuestionRepresenter < Roar::Decorator

    include Roar::JSON

    can_view_solutions_proc = ->(user_options:, **) do
      user_options[:can_view_solutions] = exercise.can_view_solutions?(user_options[:user]) \
        if user_options[:can_view_solutions].nil?

      user_options[:can_view_solutions]
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
               setter: AR_COLLECTION_SETTER,
               schema_info: {
                 required: true
               }

    collection :answers,
               instance: ->(*) { Answer.new(question: self) },
               extend: AnswerRepresenter,
               writeable: true,
               readable: true,
               setter: AR_COLLECTION_SETTER,
               schema_info: {
                 required: true
               }

    collection :collaborator_solutions,
               class: CollaboratorSolution,
               extend: CollaboratorSolutionRepresenter,
               writeable: true,
               readable: true,
               if: can_view_solutions_proc,
               setter: AR_COLLECTION_SETTER

    collection :community_solutions,
               class: CommunitySolution,
               extend: CommunitySolutionRepresenter,
               writeable: false,
               readable: true,
               if: can_view_solutions_proc

    collection :hints,
               type: String,
               readable: true,
               serialize: ->(input:, **) { input.content },
               writeable: true,
               class: Hint,
               deserialize: ->(input:, fragment:, **) do
                 input.tap { |input| input.content = fragment }
               end,
               setter: AR_COLLECTION_SETTER,
               schema_info: {
                 required: true,
                 description: 'Author-supplied hints for the question'
               }

    collection :parent_dependencies,
               as: :dependencies,
               instance: ->(*) { QuestionDependency.new(dependent_question: self) },
               extend: QuestionDependencyRepresenter,
               writeable: true,
               readable: true,
               setter: AR_COLLECTION_SETTER,
               schema_info: {
                 required: true
               }

  end
end
