module Admin
  class UsersController < BaseController
    before_action :set_user, only: [:show, :edit, :update, :become, :delete, :undelete]

  # GET /users
    def index
      handle_with Admin::UsersSearch
    end

    # PUT /users/1/become
    def become
      sign_in @user
      redirect_to root_url, notice: "Logged in as #{@user.name}"
    end

    # PATCH /users/1/delete
    def delete
      @user.delete
      respond_to do |format|
        format.html do
          redirect_to admin_users_url, notice: "#{@user.name}'s account has been disabled."
        end
        format.js { render 'admin/users/delete' }
      end
    end

    # PATCH /users/1/undelete
    def undelete
      @user.undelete
      respond_to do |format|
        format.html do
          redirect_to admin_users_url, notice: "#{@user.name}'s account has been enabled."
        end
        format.js { render 'admin/users/delete' }
      end
    end

    protected

    def set_user
      @user = User.find(params[:id])
    end
  end
end
