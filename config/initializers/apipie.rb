# Ideally Apipie would use Markdown for writing things like method descriptions,
# etc.  This is great except that it is very indentation sensitive.  When we use
# multiline heredocs and interpolate indentation sensitive multiline strings into
# it (e.g. JSON schema strings derived from our Representable representers), things
# get all messed up format-wise.  So we do two things: 
# 
# 1) We assume that the indentation of the first line of a heredoc is what should 
#    be removed from all lines (hence the first two lines of the 'to_html' method)
# 2) This can be a problem when we embed a multiline preformatted string (where 
#    indentation is important), so our hack is to use "funky" indentation characters
#    instead of spaces at the start of lines in that preformatted code.  That way
#    when we remove spaces from the start of lines in the preformatted block we don't
#    mess up the intentional indentation.
#
# Sucks, I know.  If someone knows a better approach I'm all ears.

FUNKY_INDENT_CHARS = "^!"

class MarkdownWrapper
  def initialize
    require 'maruku'
  end

  def to_html(text)
    re = Regexp.new('^\s{' + text[/\A[ \t]*/].size.to_s + '}')
    text.gsub!(re, '')
    text.gsub!(Regexp.new(Regexp.escape(FUNKY_INDENT_CHARS)),'  ')
    Maruku.new(text).to_html
  end
end

Apipie.configure do |config|
  config.app_name                = "#{SITE_NAME} API"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/api/docs"
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/**/*.rb"
  config.copyright               = Utilities::copyright_text
  config.layout                  = 'application_body_api_docs'
  config.markup                  = MarkdownWrapper.new
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

    Many of the API specifications provide a related JSON schema.  These schemas are based on the 
    standard being defined at [http://json-schema.org/](http://json-schema.org/).
  eos
end
