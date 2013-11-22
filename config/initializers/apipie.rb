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
    Access to the API requires either a valid ID and secret key combination or having a user
    that is logged in to the system.  

    When communicating with the API, developers must set a header in the HTTP request to specify
    which version of the API they want to use:

    <table class='std-list-1' style='width: 80%; margin: 15px auto'>
      <tr>
        <th>Header Name</th>
        <th>Value</th>
        <th>Version Accessed</th>
      </tr>
      <tr>
        <td><code>'Accept'</code></td>
        <td><code>'application/vnd.exercises.openstax.v1'</code></td>
        <td>v1</td>
      </tr>
    </table>
  eos
end
