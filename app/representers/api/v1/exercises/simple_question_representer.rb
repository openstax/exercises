module Api::V1::Exercises
  class SimpleQuestionRepresenter < BaseRepresenter

    property :id,
             type: Integer,
             writeable: false,
             readable: true,
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

    property :stem,
             as: :stem_html,
             type: String,
             writeable: true,
             readable: true,
             getter: ->(*) do
               stems << Stem.new(question: self) if stems.empty?

               stems.first.content
             end,
             setter: ->(options) do
               stems << Stem.new(question: self) if stems.empty?

               stems.first.content = options[:input]
             end,
             schema_info: {
               required: true
             },
             if: CACHED_PUBLIC_FIELDS

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

    collection :formats,
               type: String,
               readable: true,
               getter: ->(*) do
                 stems << Stem.new(question: self) if stems.empty?

                 stems.first.stylings
               end,
               serialize: ->(options) { options[:input].style },
               writeable: true,
               class: Styling,
               deserialize: ->(options) do
                 options[:input].tap { |input| input.style = options[:fragment] }
               end,
               setter: AR_COLLECTION_SETTER,
               schema_info: {
                 required: true,
                 description: 'The formats allowed for this object'
               },
               if: CACHED_PUBLIC_FIELDS

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
