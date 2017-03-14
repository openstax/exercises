module Api::V1
  class SimpleQuestionRepresenter < Roar::Decorator

    include Roar::JSON

    can_view_solutions_proc = ->(user_options:, **) do
      user_options[:can_view_solutions] ||=
        user_options.has_key?(:can_view_solutions) ?
          user_options[:can_view_solutions] :
          exercise.can_view_solutions?(user_options[:user])
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
             getter: ->(*) { stems.first.try(:content) || '' },
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

    collection :formats,
               type: String,
               writeable: true,
               readable: true,
               getter: ->(*) { stems.first.try(:stylings).try(:map, &:style) },
               setter: ->(input:, **) do
                 input.each do |val|
                   styling = stems.first.stylings.find_or_initialize_by(style: val)
                   styling.stylable = stems.first
                   stems.first.stylings << styling unless styling.persisted?
                 end
               end,
               schema_info: {
                 required: true,
                 description: 'The formats allowed for this object'
               }

    collection :combo_choices,
               class: ComboChoice,
               extend: ComboChoiceRepresenter,
               writeable: true,
               readable: true,
               getter: ->(*) { stems.first.try(:combo_choices) },
               setter: ->(input:, **) { stems.first.combo_choices = input }

  end
end
