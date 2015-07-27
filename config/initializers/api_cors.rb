OpenStax::Api::V1::ApiController.class_exec do

  before_filter :set_cors_preflight_headers
  after_filter :set_cors_headers

end
