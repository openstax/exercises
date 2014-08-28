class LogicVariablesController < ApplicationController
  before_action :set_logic_variable, only: [:show, :edit, :update, :destroy]

  # GET /logic_variables
  def index
    @logic_variables = LogicVariable.all
  end

  # GET /logic_variables/1
  def show
  end

  # GET /logic_variables/new
  def new
    @logic_variable = LogicVariable.new
  end

  # GET /logic_variables/1/edit
  def edit
  end

  # POST /logic_variables
  def create
    @logic_variable = LogicVariable.new(logic_variable_params)

    if @logic_variable.save
      redirect_to @logic_variable, notice: 'Logic variable was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /logic_variables/1
  def update
    if @logic_variable.update(logic_variable_params)
      redirect_to @logic_variable, notice: 'Logic variable was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /logic_variables/1
  def destroy
    @logic_variable.destroy
    redirect_to logic_variables_url, notice: 'Logic variable was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_logic_variable
      @logic_variable = LogicVariable.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def logic_variable_params
      params.require(:logic_variable).permit(:logic_id, :variable)
    end
end
