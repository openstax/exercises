class CollaboratorsController < ApplicationController
  # GET /collaborators
  # GET /collaborators.json
  def index
    @collaborators = Collaborator.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @collaborators }
    end
  end

  # GET /collaborators/new
  # GET /collaborators/new.json
  def new
    @collaborator = Collaborator.new
    raise_exception_unless(@collaborator.can_be_created_by?(current_user))

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @collaborator }
    end
  end

  # POST /collaborators
  # POST /collaborators.json
  def create
    @collaborator = Collaborator.new(params[:collaborator])
    raise_exception_unless(@collaborator.can_be_created_by?(current_user))

    respond_to do |format|
      if @collaborator.save
        format.html { redirect_to @collaborator, notice: 'Collaborator was successfully created.' }
        format.json { render json: @collaborator, status: :created, location: @collaborator }
      else
        format.html { render action: "new" }
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
      format.html { redirect_to collaborators_url }
      format.json { head :no_content }
    end
  end
end
