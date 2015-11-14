module Api::V1
  class ExerciseRepresenter < PublicationRepresenter

    has_attachments
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
