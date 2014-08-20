module Api::V1
  class SolutionsController < OpenStax::Api::V1::ApiController

    resource_description do
      api_versions "v1"
      short_description 'Represents a solution for an Exercise.'
      description <<-EOS
        Solutions teach Users how to solve an Exercise.
      EOS
    end

  end
end
