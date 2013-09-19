module UserSearch
  def user_search
    @query = params[:query] || ''
    @type = params[:type] || 'Name'
    @users = User.search(@query, @type)

    respond_to do |format|
      format.html do
        @users = @users.paginate(:page => params[:page], :per_page => @per_page)
      end
      format.json { render json: @users }
    end
  end

  def user_search_error_html(error_action = 'new')
    @query = params[:query] || ''
    @type = params[:type] || 'Name'
    @users = User.search(@query, @type)\
                 .paginate(:page => params[:page], :per_page => @per_page)

    render action: error_action
  end
end

ActionController::Base.send :include, UserSearch
