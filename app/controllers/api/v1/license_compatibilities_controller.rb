module Api::V1
  class LicenseCompatibilitiesController < OpenStax::Api::V1::ApiController

    resource_description do
      api_versions "v1"
      short_description 'Represents the compatiblity between two copyright Licenses.'
      description <<-EOS
        LicenseCompatibilities represents the compatiblity between two copyright Licenses.
      EOS
    end

  end
end
