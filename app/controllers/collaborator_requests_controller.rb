class CollaboratorRequestsController < ApplicationController
  # GET /collaborator_requests
  # GET /collaborator_requests.json
  def index
    @collaborator_requests = CollaboratorRequest.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @collaborator_requests }
    end
  end

  # GET /collaborator_requests/1
  # GET /collaborator_requests/1.json
  def show
    @collaborator_request = CollaboratorRequest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @collaborator_request }
    end
  end

  # GET /collaborator_requests/new
  # GET /collaborator_requests/new.json
  def new
    @collaborator_request = CollaboratorRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @collaborator_request }
    end
  end

  # GET /collaborator_requests/1/edit
  def edit
    @collaborator_request = CollaboratorRequest.find(params[:id])
  end

  # POST /collaborator_requests
  # POST /collaborator_requests.json
  def create
    @collaborator_request = CollaboratorRequest.new(params[:collaborator_request])

    respond_to do |format|
      if @collaborator_request.save
        format.html { redirect_to @collaborator_request, notice: 'Collaborator request was successfully created.' }
        format.json { render json: @collaborator_request, status: :created, location: @collaborator_request }
      else
        format.html { render action: "new" }
        format.json { render json: @collaborator_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /collaborator_requests/1
  # PUT /collaborator_requests/1.json
  def update
    @collaborator_request = CollaboratorRequest.find(params[:id])

    respond_to do |format|
      if @collaborator_request.update_attributes(params[:collaborator_request])
        format.html { redirect_to @collaborator_request, notice: 'Collaborator request was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @collaborator_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collaborator_requests/1
  # DELETE /collaborator_requests/1.json
  def destroy
    @collaborator_request = CollaboratorRequest.find(params[:id])
    @collaborator_request.destroy

    respond_to do |format|
      format.html { redirect_to collaborator_requests_url }
      format.json { head :no_content }
    end
  end
end
