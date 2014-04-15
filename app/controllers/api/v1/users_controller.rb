class Api::V1::UsersController < OpenStax::Api::V1::ApiController

  resource_description do
    api_versions "v1"
    short_description 'TBD'
    description <<-EOS
      TBD
    EOS
  end

  ###############################################################
  # search
  ###############################################################

  api :GET, '/users/search', 'Return a set of Users matching query terms'
  description <<-EOS
    Accepts a query string along with options and returns a JSON representation
    of the matching Users.  Some User data may be filtered out depending on the
    caller's status and priviledges in the system.  The schema for the returned
    JSON result is shown below. 

    <p>Currently, access to this API is limited to trusted applications where the 
    application is making the API call on its own behalf, not on the behalf of
    a user.</p>

    #{json_schema(Api::V1::UserSearchRepresenter, include: :readable)}            
  EOS
  # Using route helpers doesn't work in test or production, probably has to do with initialization order
  example "#{api_example(url_base: 'https://accounts.openstax.org/api/users/search', url_end: '?q=username:bob%20name=Jones')}"
  param :q, String, required: true, desc: <<-EOS
    The search query string, built up as a space-separated collection of
    search conditions on different fields.  See the documentation in OpenStax accounts.
  EOS
  def search
    OSU::AccessPolicy.require_action_allowed!(:search, current_user, User)
    outputs = SearchUsers.call(params[:q]).outputs
    respond_with outputs, represent_with: Api::V1::UserSearchRepresenter
  end

end