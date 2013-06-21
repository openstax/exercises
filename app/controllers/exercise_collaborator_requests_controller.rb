class ExerciseCollaboratorRequestsController < ApplicationController
  # GET /exercise_collaborator_requests
  # GET /exercise_collaborator_requests.json
  def index
    @exercise_collaborator_requests = ExerciseCollaboratorRequest.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @exercise_collaborator_requests }
    end
  end

  # GET /exercise_collaborator_requests/1
  # GET /exercise_collaborator_requests/1.json
  def show
    @exercise_collaborator_request = ExerciseCollaboratorRequest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @exercise_collaborator_request }
    end
  end

  # GET /exercise_collaborator_requests/new
  # GET /exercise_collaborator_requests/new.json
  def new
    @exercise_collaborator_request = ExerciseCollaboratorRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @exercise_collaborator_request }
    end
  end

  # GET /exercise_collaborator_requests/1/edit
  def edit
    @exercise_collaborator_request = ExerciseCollaboratorRequest.find(params[:id])
  end

  # POST /exercise_collaborator_requests
  # POST /exercise_collaborator_requests.json
  def create
    @exercise_collaborator_request = ExerciseCollaboratorRequest.new(params[:exercise_collaborator_request])

    respond_to do |format|
      if @exercise_collaborator_request.save
        format.html { redirect_to @exercise_collaborator_request, notice: 'Exercise collaborator request was successfully created.' }
        format.json { render json: @exercise_collaborator_request, status: :created, location: @exercise_collaborator_request }
      else
        format.html { render action: "new" }
        format.json { render json: @exercise_collaborator_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /exercise_collaborator_requests/1
  # PUT /exercise_collaborator_requests/1.json
  def update
    @exercise_collaborator_request = ExerciseCollaboratorRequest.find(params[:id])

    respond_to do |format|
      if @exercise_collaborator_request.update_attributes(params[:exercise_collaborator_request])
        format.html { redirect_to @exercise_collaborator_request, notice: 'Exercise collaborator request was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @exercise_collaborator_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exercise_collaborator_requests/1
  # DELETE /exercise_collaborator_requests/1.json
  def destroy
    @exercise_collaborator_request = ExerciseCollaboratorRequest.find(params[:id])
    @exercise_collaborator_request.destroy

    respond_to do |format|
      format.html { redirect_to exercise_collaborator_requests_url }
      format.json { head :no_content }
    end
  end
end
