module Api::V1::Exercises
  class AnswerRepresenter < BaseRepresenter

    property :id,
             type: Integer,
             writeable: true,
             readable: true,
             setter: ->(options) { self.temp_id = options[:input] },
             schema_info: {
               required: true
             }

    property :content,
             as: :content_html,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

  end
end
