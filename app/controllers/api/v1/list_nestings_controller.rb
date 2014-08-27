module Api::V1
  class ListNestingsController < OpenStax::Api::V1::ApiController

    resource_description do
      api_versions "v1"
      short_description 'Represents a nested list.'
      description <<-EOS
        ListNestings represent nested lists.
      EOS
    end

  end
end
