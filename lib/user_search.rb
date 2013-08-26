module UserSearch
  def user_search
    @query = params[:query] || ''
    @type = params[:type] || 'Name'
    @users = User.search(@query, @type)

    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end

  def user_search_error_html(error_action = 'new')
    @query = params[:query] || ''
    @type = params[:type] || 'Name'
    @users = User.search(@query, @type)

    render action: error_action
  end
end

ActionController::Base.send :include, UserSearch
