class DeputizationsController < ApplicationController

  # GET /deputizations
  def index
    @deputizations = current_user.child_deputizations
    handle_with UsersIndex
  end

  # POST /deputizations
  def create
    @deputization = Deputization.new(deputization_params)
    @deputization.deputizer = current_user
    OSU::AccessPolicy.require_action_allowed!(:create, current_user, @deputization)

    respond_to do |format|
      if @deputization.save
        format.html { redirect_to deputizations_url,
                                  notice: "#{@deputization.deputy.name} is now your deputy." }
      else
        format.html { render action: "index" }
      end
    end
  end

  # DELETE /deputizations/1
  def destroy
    @deputization = Deputization.find(params[:id])
    OSU::AccessPolicy.require_action_allowed!(:destroy, current_user, @deputization)

    @deputization.destroy
    redirect_to deputizations_url,
                notice: "#{@deputization.deputy.name} is no longer your deputy."
  end

  protected

  # Only allow a trusted parameter "white list" through.
  def deputization_params
    params.require(:deputization).permit(:deputy_type, :deputy_id)
  end

end
