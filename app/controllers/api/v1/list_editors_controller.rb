module Api::V1
  class ListEditorsController < OpenStax::Api::V1::ApiController

    resource_description do
      api_versions "v1"
      short_description 'Represents an editor of a list.'
      description <<-EOS
        ListEditors represent editors of Lists.
      EOS
    end

  end
end
