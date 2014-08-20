module Api::V1
  class DerivationsController < OpenStax::Api::V1::ApiController

    resource_description do
      api_versions "v1"
      short_description 'Represents a derived copy of an Exercise.'
      description <<-EOS
        Derivations represents a derived copy of an Exercise.
      EOS
    end

  end
end
