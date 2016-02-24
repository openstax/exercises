module Api::V1
  class AttachmentRepresenter < Roar::Decorator

    include Roar::JSON

    property :id,
             type: String,
             writeable: false,
             readable: true

    property :asset,
             type: String,
             readable: true,
             writeable: false,
             getter: ->(*) { asset.as_json[:asset] },
             schema_info: {
               required: true
             }

  end
end
