module Api::V1
  class LicenseRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :name,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

    property :title,
             type: String,
             writeable: false,
             readable: true

    property :url,
             type: String,
             writeable: false,
             readable: true

    property :requires_attribution,
             writeable: false,
             readable: true,
             schema_info: {
               type: 'boolean'
             }

    property :share_alike,
             writeable: false,
             readable: true,
             schema_info: {
               type: 'boolean'
             }

    property :no_derivatives,
             writeable: false,
             readable: true,
             schema_info: {
               type: 'boolean'
             }

    property :non_commercial,
             writeable: false,
             readable: true,
             schema_info: {
               type: 'boolean'
             }

  end
end
