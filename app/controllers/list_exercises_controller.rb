class ListExercisesController < ApplicationController
  before_filter :get_list, :only => [:new, :create]

  # GET /list_exercises/new
  # GET /list_exercises/new.json
  def new
    @per_page = params[:per_page] || 20
    @query = params[:query] || ''
    @part = params[:part] || 'content/answers'
    @answer_type = params[:answer_type] || 'any answer types'

    @exercises = Exercise.search(@query, @part, 'published exercises', @answer_type, current_user)

    respond_to do |format|
      format.html do
        @exercises = @exercises.paginate(:page => params[:page], :per_page => @per_page)
      end
      format.json { render json: @exercises }
    end
  end

  # POST /list_exercises
  # POST /list_exercises.json
  def create
    exercise = Exercise.find(params[:exercise_id])

    @list_exercise = @list.add_exercise(exercise)
    respond_to do |format|
      if @list_exercise.persisted?
        format.html { redirect_to @list, notice: 'Exercise was successfully added to list.' }
        format.json { render json: @list_exercise, status: :created, location: @list_exercise }
      else
        format.html do
          @per_page = params[:per_page] || 20
          @query = params[:query] || ''
          @part = params[:part] || 'content/answers'
          @answer_type = params[:answer_type] || 'any answer types'

          @exercises = Exercise.search(@query, @part, 'published exercises', @answer_type, current_user) \
                               .paginate(:page => params[:page], :per_page => @per_page)

          render action: "new"
        end
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
