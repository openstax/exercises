module Api::V1
  class LibraryRepresenter < PublicationRepresenter

    property :name, 
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

    property :language, 
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
