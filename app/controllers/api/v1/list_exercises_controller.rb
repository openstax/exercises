class ListExercisesController < ApplicationController
  before_filter :get_list, :only => [:new, :create]

  # GET /lists/1/list_exercises/new
  # GET /lists/1/list_exercises/new.json
  def new
    exercise_search(true)
  end

  # POST /lists/1/list_exercises
  # POST /lists/1/list_exercises.json
  def create
    exercise = Exercise.find(params[:exercise_id])

    @list_exercise = @list.add_exercise(exercise)
    respond_to do |format|
      if @list_exercise.persisted?
        format.html { redirect_to @list, notice: 'Exercise was successfully added to list.' }
        format.json { render json: @list_exercise, status: :created, location: @list_exercise }
      else
        format.html { exercise_search_error_html(true) }
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
      format.html { redirect_to @list_exercise.list }
      format.json { head :no_content }
    end
  end

  protected

  def get_list
    @list = List.find(params[:list_id])
    raise_exception_unless(@list.can_be_edited_by?(current_user))
  end
end
