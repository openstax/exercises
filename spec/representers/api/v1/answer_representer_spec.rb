module Api::V1
  describe AnswerRepresenter do

    include Roar::Representer::JSON

    property :id,
             type: Integer,
             writeable: true,
             readable: true,
             setter: lambda { |val| self.temp_id = val },
             schema_info: {
               required: true
             }

    property :question_id,
             type: Integer,
             writeable: false,
             readable: true

    property :content,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

  end
end
