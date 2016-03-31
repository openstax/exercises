module Api::V1
  class AnswerRepresenter < Roar::Decorator

    include Roar::JSON

    property :id,
             type: Integer,
             writeable: true,
             readable: true,
             setter: lambda { |val, *| self.temp_id = val },
             getter: lambda { |*| id || temp_id! },
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
