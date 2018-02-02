module Api::V1::Exercises
  class SimpleQuestionRepresenter < BaseRepresenter

    property :id,
             type: Integer,
             writeable: false,
             readable: true,
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

    property :stem,
             as: :stem_html,
             type: String,
             writeable: true,
             readable: true,
             getter: ->(*) do
               stems << Stem.new(question: self) if stems.empty?

               stems.first.content
             end,
             setter: ->(input:, **) do
               stems << Stem.new(question: self) if stems.empty?

               stems.first.content = input
             end,
             schema_info: {
               required: true
             },
             if: NOT_SOLUTIONS_ONLY

    collection :answers,
               instance: ->(*) { Answer.new(question: self) },
               extend: SimpleAnswerRepresenter,
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

    collection :formats,
               type: String,
               readable: true,
               getter: ->(*) do
                 stems << Stem.new(question: self) if stems.empty?

                 stems.first.stylings
               end,
               serialize: ->(input:, **) { input.style },
               writeable: true,
               class: Styling,
               deserialize: ->(input:, fragment:, **) do
                 input.tap { |input| input.style = fragment }
               end,
               setter: AR_COLLECTION_SETTER,
               schema_info: {
                 required: true,
                 description: 'The formats allowed for this object'
               },
               if: NOT_SOLUTIONS_ONLY

    collection :combo_choices,
               class: ComboChoice,
               extend: ComboChoiceRepresenter,
               writeable: true,
               readable: true,
               getter: ->(*) do
                 stems << Stem.new(question: self) if stems.empty?

                 stems.first.combo_choices
               end,
               setter: AR_COLLECTION_SETTER

  end
end
