class UserGroupUsersController < ApplicationController
  before_filter :get_user_group, :only => [:new, :create]

  # GET /user_group_users
  # GET /user_group_users.json
  def index
    @user_group_users = UserGroupUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_group_users }
    end
  end

  # GET /user_group_users/new
  # GET /user_group_users/new.json
  def new
    @user_group_user = UserGroupUser.new

    @selected_type = params[:selected_type]
    @text_query = params[:text_query]
    @users = User.search(@selected_type, @text_query)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_group_user }
    end
  end

  # POST /user_group_users
  # POST /user_group_users.json
  def create
    @user_group_user = UserGroupUser.new
    @user_group_user.user_group_id = params[:user_group_id]
    @user_group_user.user_id = params[:user_id]

    respond_to do |format|
      if @user_group_user.save
        format.html { redirect_to @user_group, notice: 'User was successfully added to group.' }
        format.json { render json: @user_group_user, status: :created, location: @user_group_user }
      else
        format.html { render action: "new" }
        format.json { render json: @user_group_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_group_users/1
  # DELETE /user_group_users/1.json
  def destroy
    @user_group_user = UserGroupUser.find(params[:id])
    @user_group_user.destroy

    respond_to do |format|
      format.html { redirect_to user_groups_url }
      format.json { head :no_content }
    end
  end

  # PUT /user_group_users/1/toggle
  # PUT /user_group_users/1/toggle.json
  def toggle
    @user_group_user = UserGroupUser.find(params[:id])

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

  def get_user_group
    @user_group = UserGroup.find(params[:user_group_id])
  end
end
