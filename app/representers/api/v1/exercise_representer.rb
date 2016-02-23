module Api::V1
  class ExerciseRepresenter < PublicationRepresenter

    # Attachments may (for a while) contain collaborator solution attachments, so
    # only show them to those who can see solutions
    has_attachments(
      if: ->(args) { args.members.include?(:user) && can_view_solutions?(args[:user]) }
    )

    has_logic
    has_tags

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
               class: Question,
               decorator: lambda { |klass, *|
                 klass.nil? || klass.stems.length > 1 ? \
                   QuestionRepresenter : SimpleQuestionRepresenter
               },
               instance: lambda { |*| Question.new(exercise: self) },
               writeable: true,
               readable: true,
               schema_info: {
                 required: true
               }

  end
end
