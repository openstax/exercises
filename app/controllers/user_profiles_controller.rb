class UserProfilesController < ApplicationController
  # GET /user_profiles/1/edit
  def edit
    @user_profile = UserProfile.find(params[:id])
    raise_exception_unless(@user_profile.can_be_updated_by?(current_user))
  end

  # PUT /user_profiles/1
  # PUT /user_profiles/1.json
  def update
    @user_profile = UserProfile.find(params[:id])
    raise_exception_unless(@user_profile.can_be_updated_by?(current_user))

    respond_to do |format|
      if @user_profile.update_attributes(params[:user_profile])
        format.html { redirect_to @user_profile, notice: 'User profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_profile.errors, status: :unprocessable_entity }
      end
    end
  end
end
