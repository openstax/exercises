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

  # GET /collaborators/1
  # GET /collaborators/1.json
  def show
    @collaborator = Collaborator.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @collaborator }
    end
  end

  # GET /collaborators/new
  # GET /collaborators/new.json
  def new
    @collaborator = Collaborator.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @collaborator }
    end
  end

  # GET /collaborators/1/edit
  def edit
    @collaborator = Collaborator.find(params[:id])
  end

  # POST /collaborators
  # POST /collaborators.json
  def create
    @collaborator = Collaborator.new(params[:collaborator])

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

  # PUT /collaborators/1
  # PUT /collaborators/1.json
  def update
    @collaborator = Collaborator.find(params[:id])

    respond_to do |format|
      if @collaborator.update_attributes(params[:collaborator])
        format.html { redirect_to @collaborator, notice: 'Collaborator was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @collaborator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collaborators/1
  # DELETE /collaborators/1.json
  def destroy
    @collaborator = Collaborator.find(params[:id])
    @collaborator.destroy

    respond_to do |format|
      format.html { redirect_to collaborators_url }
      format.json { head :no_content }
    end
  end
end
