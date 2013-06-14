Apipie.configure do |config|
  config.app_name                = "#{SITE_NAME} API"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/api/docs"
  # were is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/**/*.rb"
  config.copyright               = Utilities::copyright_text
  config.layout                  = 'application_body_api_docs'
  config.markup                  = Apipie::Markup::Markdown.new
  config.namespaced_resources    = false
  config.app_info =              <<-eos
    A high-level description of the app and/or the API. sit voluptatem accusantium doloremque 
    laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi 
    architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas 
    sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione 
    voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit 
    amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut 
    labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis 
    nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi 
    consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam 
    nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?
  eos
end
