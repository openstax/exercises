class Admin::PublicationsController < Admin::BaseController
  around_action :respond_to_html, except: :users

  # GET /admin/publications
  def index
    @query = params[:query] || ''
    @type = params[:type] || 'Exercise'
    @page = Integer(params[:page]) rescue 1
    @per_page = Integer(params[:per_page]) rescue 20

    if @query.blank?
      @publishables = []
      @total_count = 0
    else
      routine = @type == 'Vocab Terms' ? SearchVocabTerms : SearchExercises
      @handler_result = routine.call(search_params, user: current_user)
      errors = @handler_result.errors
      if errors.empty?
        outputs = @handler_result.outputs
        @publishables = outputs.items
        @total_count = outputs.total_count
      end
    end

    @collaborator_action = params[:collaborator_action] || 'Add'
    collaborator_id = params[:collaborator_id]
    @collaborators = []
    if collaborator_id.blank?
      search_collaborators
    else
      @collaborator = User.find(collaborator_id)
      @collaborators_query = @collaborator.name
    end
    @collaborator_type = params[:collaborator_type]
  end

  # PATCH /admin/publications
  def update
  end

  # GET /admin/publications/collaborators.js
  def collaborators
    respond_to do |format|
      format.js do
        @collaborators = []
        search_collaborators
      end
    end
  end

  protected

  def respond_to_html
    respond_to { |format| format.html { yield } }
  end

  def search_params
    params.permit :query, :page
  end

  def search_collaborators
    @collaborators = []
    @collaborators_query = params[:collaborators_query]
    return if @collaborators_query.blank?

    params[:search] = { query: @collaborators_query }
    handle_with Admin::UsersSearch, success: -> do
      @collaborators = User.joins(:account).where(
        account: { id: @handler_result.outputs.items.map(&:id) }
      ).take(10)
    end
  end
end
