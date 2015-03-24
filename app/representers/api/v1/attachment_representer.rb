module Api::V1
  class AttachmentRepresenter < Roar::Decorator

    include Roar::JSON

    property :asset, 
             type: String,
             readable: true,
             writeable: false,
             schema_info: {
               required: true
             }

  end
end
