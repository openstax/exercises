module Api::V1::Exercises
  class QuestionRepresenter < BaseRepresenter

    property :id,
             type: Integer,
             writeable: true,
             readable: true,
             setter: ->(input:, **) { self.temp_id = input },
             if: NOT_SOLUTIONS_ONLY

    property :answer_order_matters,
             as: :is_answer_order_important,
             writeable: true,
             readable: true,
             schema_info: {
               type: 'boolean'
             },
             if: NOT_SOLUTIONS_ONLY

    property :stimulus,
             as: :stimulus_html,
             type: String,
             writeable: true,
             readable: true,
             if: NOT_SOLUTIONS_ONLY

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
               },
               if: NOT_SOLUTIONS_ONLY

    collection :collaborator_solutions,
               class: CollaboratorSolution,
               extend: CollaboratorSolutionRepresenter,
               writeable: true,
               readable: true,
               setter: AR_COLLECTION_SETTER,
               if: SOLUTIONS

    collection :community_solutions,
               class: CommunitySolution,
               extend: CommunitySolutionRepresenter,
               writeable: false,
               readable: true,
               if: SOLUTIONS

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
               },
               if: NOT_SOLUTIONS_ONLY

    collection :parent_dependencies,
               as: :dependencies,
               instance: ->(*) { QuestionDependency.new(dependent_question: self) },
               extend: QuestionDependencyRepresenter,
               writeable: true,
               readable: true,
               setter: AR_COLLECTION_SETTER,
               schema_info: {
                 required: true
               },
               if: NOT_SOLUTIONS_ONLY

  end
end
