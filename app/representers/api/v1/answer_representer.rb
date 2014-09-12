module Api::V1
  class AnswerRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: true,
             readable: true,
             setter: lambda { |val| self.temp_id = val }

    property :item_id, 
             type: Integer,
             writeable: true,
             readable: true,
             setter: lambda { |val|
               self.item = question.items.select{|i| (i.id || i.temp_id) == val}.first
             }

    property :content,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

    property :correctness,
             type: Float,
             writeable: true,
             readable: true,
             getter: lambda { |*| @correctness.to_f },
             schema_info: {
               type: 'number'
             }

  end
end
