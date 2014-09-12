module Api::V1
  class ItemRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: true,
             readable: true,
             setter: lambda { |val| self.temp_id = val }

    property :content,
             type: String,
             writeable: true,
             readable: true

  end
end
