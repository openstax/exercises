class UserGroupsController < ApplicationController
  # GET /user_groups/1
  # GET /user_groups/1.json
  def show
    @user_group = UserGroup.find(params[:id])
    raise_exception_unless(@user_group.can_be_read_by?(current_user))

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_group }
    end
  end

  # GET /user_groups/new
  # GET /user_groups/new.json
  def new
    @user_group = UserGroup.new
    raise_exception_unless(@user_group.can_be_created_by?(current_user))

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_group }
    end
  end

  # GET /user_groups/1/edit
  def edit
    @user_group = UserGroup.find(params[:id])
    raise_exception_unless(@user_group.can_be_updated_by?(current_user))
  end

  # POST /user_groups
  # POST /user_groups.json
  def create
    @user_group = UserGroup.new(params[:user_group])
    raise_exception_unless(@user_group.can_be_created_by?(current_user))

    respond_to do |format|
      begin
        @user_group.transaction do
          @user_group.save!
          raise ActiveRecord::RecordInvalid unless @user_group.add_user(current_user, true)
        end
        format.html { redirect_to @user_group, notice: 'User group was successfully created.' }
        format.json { render json: @user_group, status: :created, location: @user_group }
      rescue ActiveRecord::RecordInvalid
        format.html { render action: "new" }
        format.json { render json: @user_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_groups/1
  # PUT /user_groups/1.json
  def update
    @user_group = UserGroup.find(params[:id])
    raise_exception_unless(@user_group.can_be_updated_by?(current_user))

    respond_to do |format|
      if @user_group.update_attributes(params[:user_group])
        format.html { redirect_to @user_group, notice: 'User group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_groups/1
  # DELETE /user_groups/1.json
  def destroy
    @user_group = UserGroup.find(params[:id])
    raise_exception_unless(@user_group.can_be_destroyed_by?(current_user))

    @user_group.destroy

    respond_to do |format|
      format.html { redirect_to user_groups_url }
      format.json { head :no_content }
    end
  end
end
