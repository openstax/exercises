module Api::V1
  class ItemsController < OpenStax::Api::V1::ApiController

    resource_description do
      api_versions "v1"
      short_description 'Items are ...'
      description <<-EOS
        Items are ...
      EOS
    end

  end
end
