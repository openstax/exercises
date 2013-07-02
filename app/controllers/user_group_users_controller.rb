class UserGroupUsersController < ApplicationController
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
    @user_group = params[:user_group_id]
    @user_group_user = UserGroupUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_group_user }
    end
  end

  # POST /user_group_users
  # POST /user_group_users.json
  def create
    @user_group_user = UserGroupUser.new(params[:user_group_user])

    respond_to do |format|
      if @user_group_user.save
        format.html { redirect_to @user_group_user, notice: 'User group member was successfully created.' }
        format.json { render json: @user_group_user, status: :created, location: @user_group_user }
      else
        format.html { render action: "new" }
        format.json { render json: @user_group_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_group_users/1
  # PUT /user_group_users/1.json
  def update
    @user_group_user = UserGroupUser.find(params[:id])

    respond_to do |format|
      if @user_group_user.update_attribute(:is_manager, !@user_group_user.is_manager)
        format.html { redirect_to @user_group_user.user_group, notice: 'User group member was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
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
end
