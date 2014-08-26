module Api::V1
  class FormattingsController < OpenStax::Api::V1::ApiController

    resource_description do
      api_versions "v1"
      short_description 'Formattings are ...'
      description <<-EOS
        Formattings are ...
      EOS
    end

  end
end
