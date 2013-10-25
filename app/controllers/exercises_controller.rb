class ExercisesController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index, :show]
  before_filter :get_exercise, :only => [:show, :edit, :update, :destroy, :dependencies, :derive, :new_version]

  # GET /exercises
  # GET /exercises.json
  def index
    exercise_search
  end

  # GET /exercises/1
  # GET /exercises/1.json
  def show
    raise_exception_unless(@exercise.can_be_read_by?(current_user))

    @lists = current_user.try(:editable_lists)
    @list_id = params[:list_id] || current_user.try(:default_list).try(:id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @exercise }
    end
  end

  # GET /exercises/new
  # GET /exercises/new.json
  def new
    @exercise = Exercise.new
    raise_exception_unless(@exercise.can_be_created_by?(current_user))
    @exercise.questions << Question.new

    current_user.ensure_default_list
    @lists = current_user.editable_lists
    @list_id = params[:list_id] || current_user.default_list.id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @exercise }
    end
  end

  # GET /exercises/1/edit
  def edit
    raise_exception_unless(@exercise.can_be_updated_by?(current_user))
  end

  # POST /exercises
  # POST /exercises.json
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
        format.json { render json: @exercise, status: :created, location: @exercise }
      rescue ActiveRecord::RecordInvalid
        format.html { render action: "new" }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /exercises/1
  # PUT /exercises/1.json
  def update
    raise_exception_unless(@exercise.can_be_updated_by?(current_user))

    respond_to do |format|
      if @exercise.update_attributes(params[:exercise])
        format.html { redirect_to @exercise, notice: 'Exercise was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exercises/1
  # DELETE /exercises/1.json
  def destroy
    raise_exception_unless(@exercise.can_be_destroyed_by?(current_user))

    @exercise.destroy

    respond_to do |format|
      format.html { redirect_to exercises_url }
      format.json { head :no_content }
    end
  end

  # GET /exercises/1/dependencies
  # GET /exercises/1/dependencies.json
  def dependencies
    @exercise = Exercise.find(params[:id])
    raise_exception_unless(@exercise.can_be_updated_by?(current_user))

    respond_to do |format|
      format.html # dependencies.html.erb
      format.json { render json: @exercise }
    end
  end

  # POST /exercises/1/derive
  # POST /exercises/1/derive.json
  def derive
    raise_exception_unless(@exercise.can_be_derived_by?(current_user))
    @list = params[:list_id].nil? ? current_user.default_list : List.find(params[:list_id])
    raise_exception_unless(@list.can_be_edited_by?(current_user))

    respond_to do |format|
      begin
        Exercise.transaction do
          @derived_exercise = @exercise.derive_for(current_user)
          raise ActiveRecord::RecordInvalid.new(@exercise) unless @list.add_exercise(@derived_exercise)
        end
        format.html { redirect_to @derived_exercise, notice: "Derivation of #{@exercise.name} was successfully created." }
        format.json { render json: @derived_exercise, status: :created, location: @derived_exercise }
      rescue ActiveRecord::RecordInvalid
        format.html { redirect_to @exercise, alert: "Derivation could not be created." }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /exercises/1/new_version
  # POST /exercises/1/new_version.json
  def new_version
    raise_exception_unless(@exercise.new_version_can_be_created_by?(current_user))
    @list = params[:list_id].nil? ? current_user.default_list : List.find(params[:list_id])
    raise_exception_unless(@list.can_be_edited_by?(current_user))

    respond_to do |format|
      begin
        Exercise.transaction do
          @new_version = @exercise.new_version
          raise ActiveRecord::RecordInvalid.new(@exercise) unless @list.add_exercise(@new_version)
        end
        format.html { redirect_to @new_version, notice: "New version of #{@exercise.name} was successfully created." }
        format.json { render json: @new_version, status: :created, location: @new_version }
      rescue ActiveRecord::RecordInvalid
        format.html { redirect_to @exercise, alert: "New version could not be created." }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  protected

  def get_exercise
    @exercise = Exercise.from_param(params[:id])
  end
end
