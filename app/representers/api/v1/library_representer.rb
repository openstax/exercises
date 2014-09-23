module Api::V1
  class LibraryRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    publishable

    property :id, 
             type: Integer,
             writeable: false,
             readable: true

    property :name, 
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

    property :description, 
             type: String,
             writeable: true,
             readable: true

    property :code, 
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

  end
end
