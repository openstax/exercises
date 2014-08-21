module Api::V1
  class ListOwnersController < OpenStax::Api::V1::ApiController

    resource_description do
      api_versions "v1"
      short_description 'Represents an owner of a list.'
      description <<-EOS
        ListOwners represent owners of Lists.
      EOS
    end

  end
end
