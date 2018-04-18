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
             getter: ->(*) do
               host = AssetUploader.asset_host
               filename = read_attribute(:asset)

               {
                 filename: filename,
                 url:      "#{host}/attachments/#{filename}",
                 large:    { url: "#{host}/attachments/large_#{filename}" },
                 medium:   { url: "#{host}/attachments/medium_#{filename}" },
                 small:    { url: "#{host}/attachments/small_#{filename}" }
               }
             end,
             schema_info: {
               required: true
             }

  end
end
