class UserGroupUsersController < ApplicationController
  before_filter :get_user_group, :only => [:new, :create]

  # GET /user_groups/1/user_group_users/new
  # GET /user_groups/1/user_group_users/new.json
  def new
    user_search
  end

  # POST /user_groups/1/user_group_users
  # POST /user_groups/1/user_group_users.json
  def create
    user = User.find(params[:user_id])

    @user_group_user = @user_group.add_user(user)
    respond_to do |format|
      if @user_group_user.persisted?
        format.html { redirect_to @user_group, notice: 'User was successfully added to group.' }
        format.json { render json: @user_group_user, status: :created, location: @user_group_user }
      else
        format.html { user_search_error_html }
        format.json { render json: @user_group_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_group_users/1
  # DELETE /user_group_users/1.json
  def destroy
    @user_group_user = UserGroupUser.find(params[:id])
    raise_exception_unless(@user_group_user.can_be_destroyed_by?(current_user))

    @user_group_user.destroy

    respond_to do |format|
      format.html { redirect_to user_groups_path }
      format.json { head :no_content }
    end
  end

  # PUT /user_group_users/1/toggle
  # PUT /user_group_users/1/toggle.json
  def toggle
    @user_group_user = UserGroupUser.find(params[:id])
    raise_exception_unless(@user_group_user.can_be_updated_by?(current_user))

    respond_to do |format|
      if @user_group_user.update_attribute(:is_manager, !@user_group_user.is_manager)
        format.html { redirect_to @user_group_user.user_group,
          notice: "#{@user_group_user.user.name} was #{@user_group_user.is_manager ? 'promoted' : 'demoted'}#{@user_group_user.is_manager ? ' to manager' : ''}." }
        format.json { head :no_content }
      else
        format.html { redirect_to @user_group_user.user_group }
        format.json { render json: @user_group_user.errors, status: :unprocessable_entity }
      end
    end
  end

  protected

  def get_user_group
    @user_group = UserGroup.find(params[:user_group_id])
    raise_exception_unless(@user_group.can_be_updated_by?(current_user))
  end
end
