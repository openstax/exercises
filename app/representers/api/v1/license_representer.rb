module Api::V1
  class LicenseRepresenter < Roar::Decorator

    include Roar::JSON

    property :name,
             type: String,
             writeable: false,
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
             as: :is_attribution_required,
             writeable: false,
             readable: true,
             schema_info: {
               type: 'boolean'
             }

    property :requires_share_alike,
             as: :is_share_alike_required,
             writeable: false,
             readable: true,
             schema_info: {
               type: 'boolean'
             }

    property :allows_derivatives,
             as: :is_derivation_allowed,
             writeable: false,
             readable: true,
             schema_info: {
               type: 'boolean'
             }

    property :allows_commercial_use,
             as: :is_commercial_use_allowed,
             writeable: false,
             readable: true,
             schema_info: {
               type: 'boolean'
             }

  end
end
