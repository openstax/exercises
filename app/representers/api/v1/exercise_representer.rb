module Api::V1
  class ExerciseRepresenter < PublicationRepresenter

    has_logic
    has_attachments

    property :title,
             type: String,
             writeable: true,
             readable: true

    property :stimulus,
             type: String,
             writeable: true,
             readable: true

    collection :questions,
               class: Question,
               decorator: lambda { |klass, *|
                klass.nil? || klass.stems.length != 1 ? \
                  QuestionRepresenter : SimpleQuestionRepresenter },
               writeable: true,
               readable: true,
               schema_info: {
                 required: true
               }

  end
end
