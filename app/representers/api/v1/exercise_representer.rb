module Api::V1
  class ExerciseRepresenter < PublicationRepresenter

    has_logic
    has_attachments

    property :title,
             type: String,
             writeable: true,
             readable: true

    property :background,
             type: String,
             writeable: true,
             readable: true

    collection :questions,
               class: Question,
               decorator: QuestionRepresenter,
               writeable: true,
               readable: true,
               schema_info: {
                 required: true
               }

  end
end
