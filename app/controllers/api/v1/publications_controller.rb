module Api::V1
  class PublicationsController < OpenStax::Api::V1::ApiController

    resource_description do
      api_versions "v1"
      short_description 'Represents a published Exercise, Solution or Rubric.'
      description <<-EOS
        Publications represent a published Exercise, Solution or Rubric.
      EOS
    end

  end
end
