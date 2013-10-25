class SolutionsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index, :show]
  before_filter :get_solution, :only => [:show, :edit, :update, :destroy, :derive, :new_version]
  before_filter :get_exercise, :only => [:index, :new, :create]

  # GET /exercise/1/solutions
  # GET /exercise/1/solutions.json
  def index
    @solutions = @exercise.solutions.visible_for(current_user).latest.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @solutions }
    end
  end

  # GET /solutions/1
  # GET /solutions/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @solution }
    end
  end

  # GET /exercise/1/solutions/new
  # GET /exercise/1/solutions/new.json
  def new
    @solution = Solution.new
    @solution.exercise = @exercise

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @solution }
    end
  end

  # GET /solutions/1/edit
  def edit
    raise_exception_unless(@solution.can_be_updated_by?(current_user))
  end

  # POST /exercise/1/solutions
  # POST /exercise/1/solutions.json
  def create
    @solution = Solution.new(params[:solution])
    @solution.exercise = @exercise

    respond_to do |format|
      if @solution.save
        @solution.add_default_collaborator(current_user)
        format.html { redirect_to exercise_solutions_path(@exercise), notice: 'Solution was successfully created.' }
        format.json { render json: @solution, status: :created, location: @solution }
      else
        format.html { render action: "new" }
        format.json { render json: @solution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /solutions/1
  # PUT /solutions/1.json
  def update
    raise_exception_unless(@solution.can_be_updated_by?(current_user))

    respond_to do |format|
      if @solution.update_attributes(params[:solution])
        format.html { redirect_to exercise_solutions_path(@solution.exercise), notice: 'Solution was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @solution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /solutions/1
  # DELETE /solutions/1.json
  def destroy
    raise_exception_unless(@solution.can_be_destroyed_by?(current_user))

    @solution.destroy

    respond_to do |format|
      format.html { redirect_to @solution.exercise }
      format.json { head :no_content }
    end
  end

  # POST /solutions/1/derive
  # POST /solutions/1/derive.json
  def derive
    raise_exception_unless(@solution.can_be_derived_by?(current_user))

    respond_to do |format|
      begin
        @derived_solution = @solution.derive_for(current_user)
        format.html { redirect_to @derived_solution, notice: "Derivation of #{@solution.name} was successfully created." }
        format.json { render json: @derived_solution, status: :created, location: @derived_solution }
      rescue ActiveRecord::RecordInvalid
        format.html { redirect_to @solution, alert: "Derivation could not be created." }
        format.json { render json: @solution.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /solutions/1/new_version
  # POST /solutions/1/new_version.json
  def new_version
    raise_exception_unless(@solution.new_version_can_be_created_by?(current_user))

    respond_to do |format|
      begin
        @new_version = @solution.new_version
        format.html { redirect_to @new_version, notice: "New version of #{@solution.name} was successfully created." }
        format.json { render json: @new_version, status: :created, location: @new_version }
      rescue ActiveRecord::RecordInvalid
        format.html { redirect_to @solution, alert: "New version could not be created." }
        format.json { render json: @solution.errors, status: :unprocessable_entity }
      end
    end
  end

  protected

  def get_solution
    @solution = Solution.from_param(params[:id])
  end

  def get_exercise
    @exercise = Exercise.from_param(params[:exercise_id])
    raise_exception_unless(!@exercise.nil? && @exercise.can_be_read_by?(current_user))
  end
end
