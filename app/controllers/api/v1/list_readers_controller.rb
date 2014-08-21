module Api::V1
  class ListReadersController < OpenStax::Api::V1::ApiController

    resource_description do
      api_versions "v1"
      short_description 'Represents a reader of a list.'
      description <<-EOS
        ListReaders represent readers of Lists.
      EOS
    end

  end
end
