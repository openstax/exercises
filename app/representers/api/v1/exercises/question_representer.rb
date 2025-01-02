module Api::V1::Exercises
  class QuestionRepresenter < BaseRepresenter

    property :id,
             type: Integer,
             writeable: true,
             readable: true,
             setter: ->(options) { self.temp_id = options[:input] },
             if: CACHED_PUBLIC_FIELDS

    property :answer_order_matters,
             as: :is_answer_order_important,
             writeable: true,
             readable: true,
             schema_info: {
               type: 'boolean'
             },
             if: CACHED_PUBLIC_FIELDS

    property :stimulus,
             as: :stimulus_html,
             type: String,
             writeable: true,
             readable: true,
             if: CACHED_PUBLIC_FIELDS

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
               if: CACHED_PUBLIC_FIELDS

    collection :collaborator_solutions,
               class: CollaboratorSolution,
               extend: CollaboratorSolutionRepresenter,
               writeable: true,
               readable: true,
               setter: AR_COLLECTION_SETTER,
               if: CACHED_PRIVATE_FIELDS

    collection :community_solutions,
               class: CommunitySolution,
               extend: CommunitySolutionRepresenter,
               writeable: false,
               readable: true,
               if: CACHED_PRIVATE_FIELDS

    collection :hints,
               type: String,
               readable: true,
               serialize: ->(options) { options[:input].content },
               writeable: true,
               class: Hint,
               deserialize: ->(options) do
                 options[:input].tap { |input| input.content = options[:fragment] }
               end,
               setter: AR_COLLECTION_SETTER,
               schema_info: {
                 required: true,
                 description: 'Author-supplied hints for the question'
               },
               if: CACHED_PUBLIC_FIELDS

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
               if: CACHED_PUBLIC_FIELDS

  end
end
