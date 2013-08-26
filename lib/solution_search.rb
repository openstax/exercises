module SolutionSearch
  def solution_search(published_only = false)
    @per_page = params[:per_page] || 20
    @query = params[:query] || ''
    @part = params[:part] || 'content/answers'
    @solution_type = published_only ? 'published solutions' : (params[:solution_type] || 'all solutions')

    @solutions = Solution.search(@query, @part, @solution_type, current_user)

    respond_to do |format|
      format.html do
        @exercises = @exercises.paginate(:page => params[:page], :per_page => @per_page)
      end
      format.json { render json: @exercises }
    end
  end

  def solution_search_error_html(published_only = false, error_action = 'new')
    @per_page = params[:per_page] || 20
    @query = params[:query] || ''
    @part = params[:part] || 'content/answers'
    @solution_type = published_only ? 'published solutions' : (params[:solution_type] || 'all solutions')

    @solutions = Solution.search(@query, @part, @solution_type, current_user) \
                         .paginate(:page => params[:page], :per_page => @per_page)

    render action: error_action
  end
end

ActionController::Base.send :include, SolutionSearch
