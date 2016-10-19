module Api::V1
  class ExerciseRepresenter < Roar::Decorator

    include Roar::JSON

    can_view_solutions_proc = ->(user_options:, **) { can_view_solutions?(user_options[:user]) }

    # Attachments may (for a while) contain collaborator solution attachments, so
    # only show them to those who can see solutions
    has_attachments(if: can_view_solutions_proc)

    has_logic
    has_tags

    publishable

    property :is_vocab?,
             as: :is_vocab,
             writeable: false,
             readable: true

    property :vocab_term_uid,
             type: Integer,
             writeable: false,
             readable: true,
             getter: ->(*) { vocab_term.try(:uid) },
             if: can_view_solutions_proc

    property :title,
             type: String,
             writeable: true,
             readable: true

    property :stimulus,
             as: :stimulus_html,
             type: String,
             writeable: true,
             readable: true

    collection :questions,
               instance: ->(*) { Question.new(exercise: self) },
               extend: ->(input:, **) {
                 input.nil? || input.stems.length > 1 ? \
                   QuestionRepresenter : SimpleQuestionRepresenter
               },
               writeable: true,
               readable: true,
               schema_info: {
                 required: true
               }

    collection :versions,
             type: Integer,
             writeable: false,
             readable: true,
             getter: ->(user_options:, **) { user_options[:versions] }

  end
end
