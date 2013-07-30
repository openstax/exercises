class ListExercisesController < ApplicationController
  # GET /list_exercises/new
  # GET /list_exercises/new.json
  def new
    @list_exercise = ListExercise.new
    raise_exception_unless(@list_exercise.can_be_created_by?(current_user))

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @list_exercise }
    end
  end

  # POST /list_exercises
  # POST /list_exercises.json
  def create
    @list_exercise = ListExercise.new(params[:list_exercise])
    raise_exception_unless(@list_exercise.can_be_created_by?(current_user))

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

  # DELETE /list_exercises/1
  # DELETE /list_exercises/1.json
  def destroy
    @list_exercise = ListExercise.find(params[:id])
    raise_exception_unless(@list_exercise.can_be_destroyed_by?(current_user))

    @list_exercise.destroy

    respond_to do |format|
      format.html { redirect_to list_exercises_url }
      format.json { head :no_content }
    end
  end
end
