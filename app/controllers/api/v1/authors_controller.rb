module Api::V1
  class AuthorsController < OpenStax::Api::V1::ApiController

    resource_description do
      api_versions "v1"
      short_description 'Authors are ...'
      description <<-EOS
        Authors are ...
      EOS
    end

  end
end
