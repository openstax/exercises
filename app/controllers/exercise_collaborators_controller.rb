class ExerciseCollaboratorsController < ApplicationController
  # GET /exercise_collaborators
  # GET /exercise_collaborators.json
  def index
    @exercise_collaborators = ExerciseCollaborator.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @exercise_collaborators }
    end
  end

  # GET /exercise_collaborators/1
  # GET /exercise_collaborators/1.json
  def show
    @exercise_collaborator = ExerciseCollaborator.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @exercise_collaborator }
    end
  end

  # GET /exercise_collaborators/new
  # GET /exercise_collaborators/new.json
  def new
    @exercise_collaborator = ExerciseCollaborator.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @exercise_collaborator }
    end
  end

  # GET /exercise_collaborators/1/edit
  def edit
    @exercise_collaborator = ExerciseCollaborator.find(params[:id])
  end

  # POST /exercise_collaborators
  # POST /exercise_collaborators.json
  def create
    @exercise_collaborator = ExerciseCollaborator.new(params[:exercise_collaborator])

    respond_to do |format|
      if @exercise_collaborator.save
        format.html { redirect_to @exercise_collaborator, notice: 'Exercise collaborator was successfully created.' }
        format.json { render json: @exercise_collaborator, status: :created, location: @exercise_collaborator }
      else
        format.html { render action: "new" }
        format.json { render json: @exercise_collaborator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /exercise_collaborators/1
  # PUT /exercise_collaborators/1.json
  def update
    @exercise_collaborator = ExerciseCollaborator.find(params[:id])

    respond_to do |format|
      if @exercise_collaborator.update_attributes(params[:exercise_collaborator])
        format.html { redirect_to @exercise_collaborator, notice: 'Exercise collaborator was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @exercise_collaborator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exercise_collaborators/1
  # DELETE /exercise_collaborators/1.json
  def destroy
    @exercise_collaborator = ExerciseCollaborator.find(params[:id])
    @exercise_collaborator.destroy

    respond_to do |format|
      format.html { redirect_to exercise_collaborators_url }
      format.json { head :no_content }
    end
  end
end
