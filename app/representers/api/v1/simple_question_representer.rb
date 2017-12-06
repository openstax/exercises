module Api::V1
  class SimpleQuestionRepresenter < Roar::Decorator

    include Roar::JSON

    can_view_solutions_proc = ->(user_options:, **) do
      user_options[:can_view_solutions] = exercise.can_view_solutions?(user_options[:user]) \
        if user_options[:can_view_solutions].nil?

      user_options[:can_view_solutions]
    end

    property :id,
             type: Integer,
             writeable: false,
             readable: true

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
             }

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
               if: can_view_solutions_proc

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
               }

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
