module Api::V1
  class ListExercisesController < OpenStax::Api::V1::ApiController

    resource_description do
      api_versions "v1"
      short_description 'Represents an Exercise in a list.'
      description <<-EOS
        ListExercises represent a Exercises in Lists.
      EOS
    end

  end
end
