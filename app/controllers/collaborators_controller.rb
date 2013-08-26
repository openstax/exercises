class CollaboratorsController < ApplicationController
  before_filter :get_publishable, :only => [:new, :create]

  # GET /publishables/1/collaborators/new
  # GET /publishables/1/collaborators/new.json
  def new
    user_search
  end

  # POST /publishables/1/collaborators
  # POST /publishables/1/collaborators.json
  def create
    user = User.find(params[:user_id])

    @collaborator = @publishable.add_collaborator(user)
    respond_to do |format|
      if @collaborator.persisted?
        format.html { redirect_to @publishable, notice: 'Collaborator was successfully added.' }
        format.json { render json: @collaborator, status: :created, location: @collaborator }
      else
        format.html { user_search_error_html }
        format.json { render json: @collaborator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collaborators/1
  # DELETE /collaborators/1.json
  def destroy
    @collaborator = Collaborator.find(params[:id])
    raise_exception_unless(@collaborator.can_be_destroyed_by?(current_user))

    @collaborator.destroy

    respond_to do |format|
      format.html { redirect_to @collaborator.publishable }
      format.json { head :no_content }
    end
  end

  # PUT /collaborators/1/toggle_author
  # PUT /collaborators/1/toggle_author.json
  def toggle_author
    @collaborator = Collaborator.find(params[:id])
    raise_exception_unless(@collaborator.can_be_updated_by?(current_user))

    respond_to do |format|
      if @collaborator.update_attribute(:toggle_author_request, !@collaborator.toggle_author_request)
        format.html { redirect_to @collaborator.publishable,
          notice: @collaborator.toggle_author_request ? \
            "A message was sent to #{@collaborator.user.name} requesting permission to make this change." : \
            "Author request cancelled" }
        format.json { head :no_content }
      else
        format.html { redirect_to @collaborator.publishable }
        format.json { render json: @collaborator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /collaborators/1/toggle_copyright_holder
  # PUT /collaborators/1/toggle_copyright_holder.json
  def toggle_copyright_holder
    @collaborator = Collaborator.find(params[:id])
    raise_exception_unless(@collaborator.can_be_updated_by?(current_user))

    respond_to do |format|
      if @collaborator.update_attribute(:toggle_copyright_holder_request, !@collaborator.toggle_copyright_holder_request)
        format.html { redirect_to @collaborator.publishable,
          notice: @collaborator.toggle_copyright_holder_request ? \
            "A message was sent to #{@collaborator.user.name} requesting permission to make this change." : \
            "Copyright holder request cancelled" }
        format.json { head :no_content }
      else
        format.html { redirect_to @collaborator.publishable }
        format.json { render json: @collaborator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /collaborators/1/accept_toggle_author
  # PUT /collaborators/1/accept_toggle_author.json
  def accept_toggle_author
    @collaborator = Collaborator.find(params[:id])
    raise_exception_unless(@collaborator.can_be_accepted_by?(current_user))

    respond_to do |format|
      if @collaborator.toggle_author_request && \
           @collaborator.update_attribute(:is_author, !@collaborator.is_author)
        @collaborator.update_attribute(:toggle_author_request, false)
        format.html { redirect_to @collaborator.publishable,
          notice: "You are #{@collaborator.is_author ? 'now' : 'no longer'} an author for #{@collaborator.publishable.name}." }
        format.json { head :no_content }
      else
        format.html { redirect_to @collaborator.publishable }
        format.json { render json: @collaborator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /collaborators/1/accept_toggle_copyright_holder
  # PUT /collaborators/1/accept_toggle_copyright_holder.json
  def accept_toggle_copyright_holder
    @collaborator = Collaborator.find(params[:id])
    raise_exception_unless(@collaborator.can_be_accepted_by?(current_user))

    respond_to do |format|
      if @collaborator.toggle_copyright_holder_request && \
           @collaborator.update_attribute(:is_copyright_holder, !@collaborator.is_copyright_holder)
        @collaborator.update_attribute(:toggle_copyright_holder_request, false)
        format.html { redirect_to @collaborator.publishable,
          notice: "You are #{@collaborator.is_copyright_holder ? 'now' : 'no longer'} a copyright holder for #{@collaborator.publishable.name}." }
        format.json { head :no_content }
      else
        format.html { redirect_to @collaborator.publishable }
        format.json { render json: @collaborator.errors, status: :unprocessable_entity }
      end
    end
  end

  protected

  def get_publishable
    @publishable = params[:exercise_id] ? Exercise.find(params[:exercise_id]) :
                   (params[:solution_id] ? Solution.find(params[:solution_id]) : nil)
    raise_exception_unless(!@publishable.nil? && @publishable.can_be_updated_by?(current_user))
  end
end
