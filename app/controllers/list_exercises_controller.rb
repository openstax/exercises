class ListExercisesController < ApplicationController
  # GET /list_exercises
  # GET /list_exercises.json
  def index
    @list_exercises = ListExercise.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @list_exercises }
    end
  end

  # GET /list_exercises/1
  # GET /list_exercises/1.json
  def show
    @list_exercise = ListExercise.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @list_exercise }
    end
  end

  # GET /list_exercises/new
  # GET /list_exercises/new.json
  def new
    @list_exercise = ListExercise.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @list_exercise }
    end
  end

  # GET /list_exercises/1/edit
  def edit
    @list_exercise = ListExercise.find(params[:id])
  end

  # POST /list_exercises
  # POST /list_exercises.json
  def create
    @list_exercise = ListExercise.new(params[:list_exercise])

    respond_to do |format|
      if @list_exercise.save
        format.html { redirect_to @list_exercise, notice: 'List exercise was successfully created.' }
        format.json { render json: @list_exercise, status: :created, location: @list_exercise }
      else
        format.html { render action: "new" }
        format.json { render json: @list_exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /list_exercises/1
  # PUT /list_exercises/1.json
  def update
    @list_exercise = ListExercise.find(params[:id])

    respond_to do |format|
      if @list_exercise.update_attributes(params[:list_exercise])
        format.html { redirect_to @list_exercise, notice: 'List exercise was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @list_exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /list_exercises/1
  # DELETE /list_exercises/1.json
  def destroy
    @list_exercise = ListExercise.find(params[:id])
    @list_exercise.destroy

    respond_to do |format|
      format.html { redirect_to list_exercises_url }
      format.json { head :no_content }
    end
  end
end
