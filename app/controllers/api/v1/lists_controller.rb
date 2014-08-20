module Api::V1
  class ListsController < OpenStax::Api::V1::ApiController

    resource_description do
      api_versions "v1"
      short_description 'Represents a List of Exercises.'
      description <<-EOS
        Lists represent lists of Exercises.
      EOS
    end

  end
end
