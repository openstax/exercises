class SolutionsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index, :show]
  before_filter :get_solution, :only => [:show, :edit, :update, :destroy, :derive, :new_version]
  before_filter :get_exercise, :only => [:index, :new, :create]

  # GET /exercise/1/solutions
  # GET /exercise/1/solutions.json
  def index
    @solutions = @exercise.solutions

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

  protected

  def get_solution
    @solution = Solution.from_param(params[:id])
  end

  def get_exercise
    @exercise = Exercise.from_param(params[:exercise_id])
    raise_exception_unless(!@exercise.nil? && @exercise.can_be_read_by?(current_user))
  end
end
