require 'uri'

class Api::V1::SwaggerController < OpenStax::Api::V1::ApiController
  include ::Swagger::Blocks

  ACCEPT_HEADER = 'application/json'
  BASE_PATH = '/api/v1'

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'OpenStax Exercises API'
      key :description, <<~DESC
        The exercises API for OpenStax.

        Requests to this API should include `#{ACCEPT_HEADER}` in the `Accept` header.

        The desired API version is specified in the request URL, e.g. `[domain]#{BASE_PATH}/highlights`. \
        While the API does support a default version, that version will change over \
        time and therefore should not be used in production code!
      DESC
      key :termsOfService, 'https://openstax.org/tos'
      contact do
        key :name, 'support@openstax.org'
      end
      license do
        key :name, 'MIT'
      end
    end
    tag do
      key :name, 'Exercises'
      key :description, 'Exercises endpoints'
    end
    key :basePath, BASE_PATH
    key :consumes, [ACCEPT_HEADER]
    key :produces, ['application/json']
  end

  SWAGGERED_CLASSES = [
    Api::V1::SwaggerResponses,
    Api::V1::UsersSwagger,
    self,
  ].freeze

  def json
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
