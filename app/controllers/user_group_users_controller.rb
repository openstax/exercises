class UserGroupUsersController < ApplicationController
  before_filter :get_user_group, :only => [:new, :create]

  # GET /user_group_users/new
  # GET /user_group_users/new.json
  def new
    @query = params[:query] || ''
    @type = params[:type] || 'Name'
    @users = User.search(@query, @type)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @users }
    end
  end

  # POST /user_group_users
  # POST /user_group_users.json
  def create
    user = User.find(params[:user_id])

    @user_group_user = @user_group.add_user(user)
    respond_to do |format|
      if @user_group_user.persisted?
        format.html { redirect_to @user_group, notice: 'User was successfully added to group.' }
        format.json { render json: @user_group_user, status: :created, location: @user_group_user }
      else
        format.html do
          @query = params[:query] || ''
          @type = params[:type] || 'Name'
          @users = User.search(@query, @type)

          render action: "new"
        end
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
      format.html { redirect_to @user_group_user.user_group }
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
          notice: "#{@user_group_user.user.name} was #{@user_group_user.is_manager ? 'promoted' : 'demoted'} to #{@user_group_user.is_manager ? 'manager' : 'member'}." }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
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
