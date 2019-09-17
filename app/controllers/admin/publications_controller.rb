class Admin::PublicationsController < Admin::BaseController
  around_action :respond_to_html, except: :users
  before_action :set_variables, except: :users

  # GET /admin/publications
  def index
  end

  # PATCH /admin/publications
  def update
    preload = case @collaborator_type
    when 'Author'
      :authors
    when 'Copyright Holder'
      :copyright_holders
    else
      [ :authors, :copyright_holders ]
    end

    publishables = @publishables.limit(nil).offset(nil)
    ActiveRecord::Associations::Preloader.new.preload publishables, publication: preload

    case @collaborator_action
    when 'Add'
      Admin::AddCollaborator.call(
        publishables: publishables,
        user: @collaborator,
        collaborator_type: @collaborator_type
      )
    when 'Remove'
      Admin::RemoveCollaborator.call(
        publishables: publishables,
        user: @collaborator,
        collaborator_type: @collaborator_type
      )
    else
      flash.now[:alert] = "Invalid action: #{@collaborator_action}"
      render 'index'
      return
    end

    flash[:notice] = "#{@collaborator.name} #{
      @collaborator_action == 'Add' ? 'added to' : 'removed from'
    } #{@total_count} publication(s)"

    redirect_to admin_publications_url(
      query: @query,
      type: @type,
      page: @page,
      per_page: @per_page
    )
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

  def set_variables
    @query = params[:query] || ''
    @type = params[:type] || 'Exercise'
    @page = Integer(params[:page]) rescue 1
    @per_page = Integer(params[:per_page]) rescue 20

    if @query.blank?
      @publishables = Publication.none
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
