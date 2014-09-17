class UsersController < ApplicationController

  before_filter :set_user

  # GET /user
  def show
  end

  # PATCH /user
  def update
    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to user_url,
                      notice: 'User profile was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /user
  def destroy
    @user.destroy
    redirect_to home_url
  end

  protected

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_user
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:first_name, :last_name,
      :full_name, :title, :show_public_domain_attribution,
      :forward_notifications_to_deputies, :receive_role_notifications,
      :receive_access_notifications, :receive_comment_notifications)
  end

end
