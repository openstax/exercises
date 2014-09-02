class DeputizationsController < ApplicationController

  # GET /deputizations
  def index
    current_user.child_deputizations
    require_action_allowed!(:index, current_user, Deputization)
  end

  # GET /deputizations/new
  def new
    @deputization = Deputization.new(deputizer: current_user)
    require_action_allowed!(:create, current_user, @deputization)
  end

  # POST /deputizations
  def create
    @deputization = Deputization.new(deputization_params)
    @deputization.deputizer = current_user
    require_action_allowed!(:create, current_user, @deputization)

    respond_to do |format|
      if @deputization.save
        format.html { redirect_to deputizations_url,
                                  notice: 'Deputization was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # DELETE /deputizations/1
  def destroy
    @deputization = Deputization.find(params[:id])
    require_action_allowed!(:destroy, current_user, @deputization)

    @deputization.destroy
    redirect_to deputizations_url
  end

  protected

  # Only allow a trusted parameter "white list" through.
  def deputization_params
    params.require(:deputization).permit(:deputy_type, :deputy_id)
  end

end
