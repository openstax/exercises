class UserGroupMembersController < ApplicationController
  # GET /user_group_members
  # GET /user_group_members.json
  def index
    @user_group_members = UserGroupMember.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_group_members }
    end
  end

  # GET /user_group_members/new
  # GET /user_group_members/new.json
  def new
    @user_group = params[:user_group_id]
    @user_group_member = UserGroupMember.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_group_member }
    end
  end

  # POST /user_group_members
  # POST /user_group_members.json
  def create
    @user_group_member = UserGroupMember.new(params[:user_group_member])

    respond_to do |format|
      if @user_group_member.save
        format.html { redirect_to @user_group_member, notice: 'User group member was successfully created.' }
        format.json { render json: @user_group_member, status: :created, location: @user_group_member }
      else
        format.html { render action: "new" }
        format.json { render json: @user_group_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_group_members/1
  # PUT /user_group_members/1.json
  def update
    @user_group_member = UserGroupMember.find(params[:id])

    respond_to do |format|
      if @user_group_member.update_attribute(:is_manager, !@user_group_member.is_manager)
        format.html { redirect_to @user_group_member.user_group, notice: 'User group member was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_group_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_group_members/1
  # DELETE /user_group_members/1.json
  def destroy
    @user_group_member = UserGroupMember.find(params[:id])
    @user_group_member.destroy

    respond_to do |format|
      format.html { redirect_to user_groups_url }
      format.json { head :no_content }
    end
  end
end
