class ExercisesController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index, :show]

  fine_print_skip_signatures :general_terms_of_use, 
                             :privacy_policy,
                             only: [:index, :show]

  before_filter :get_exercise, :only => [:show, :edit, :update, :destroy, 
                                         :dependencies, :derive, :new_version]

  def index
    exercise_search
  end

  def show
    raise_exception_unless(@exercise.can_be_read_by?(current_user))

    @lists = current_user.try(:editable_lists)
    @list_id = params[:list_id] || current_user.try(:default_list).try(:id)
  end

  def new
    redirect_to Exercise.create

    # @exercise = Exercise.new
    # raise_exception_unless(@exercise.can_be_created_by?(current_user))
    # @exercise.questions << Question.new

    # current_user.ensure_default_list
    # @lists = current_user.editable_lists
    # @list_id = params[:list_id] || current_user.default_list.id

  end

  def edit
    raise_exception_unless(@exercise.can_be_updated_by?(current_user))
  end

  def create
    @exercise = Exercise.new(params[:exercise])
    raise_exception_unless(@exercise.can_be_created_by?(current_user))
    @list = params[:list_id].nil? ? current_user.default_list : List.find(params[:list_id])
    raise_exception_unless(@list.can_be_edited_by?(current_user))

    @lists = current_user.editable_lists
    @list_id = @list.id

    respond_to do |format|
      begin
        @exercise.transaction do
          @exercise.save!
          raise ActiveRecord::RecordInvalid unless @list.add_exercise(@exercise)
        end
        @exercise.add_default_collaborator(current_user)
        format.html { redirect_to @exercise, notice: 'Exercise was successfully created.' }
      rescue ActiveRecord::RecordInvalid
        format.html { render action: "new" }
      end
    end
  end

  def update
    raise_exception_unless(@exercise.can_be_updated_by?(current_user))

    respond_to do |format|
      if @exercise.update_attributes(params[:exercise])
        format.html { redirect_to @exercise, notice: 'Exercise was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    raise_exception_unless(@exercise.can_be_destroyed_by?(current_user))
    @exercise.destroy
    redirect_to exercises_url
  end

  def dependencies
    @exercise = Exercise.find(params[:id])
    raise_exception_unless(@exercise.can_be_updated_by?(current_user))
  end

protected

  def get_exercise
    @exercise = Exercise.from_param(params[:id])
  end
end
