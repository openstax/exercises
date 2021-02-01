module Api::V1
  class ImageRepresenter < Roar::Decorator
    include Roar::JSON

    property :id,
             type: String,
             writeable: false,
             readable: true

    property :created_at,
             type: String,
             readable: true,
             writeable: false,
             getter: ->(*) { DateTimeUtilities.to_api_s(created_at) },
             schema_info: { required: true }
  end
end
