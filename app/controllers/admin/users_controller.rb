module Admin
  class UsersController < BaseController

    before_filter :set_user, only: [:show, :edit, :update, :become, :delete, :undelete]

  # GET /users
    def index
      handle_with(Admin::UsersIndex,
                  complete: lambda { render 'admin/users/index' })
    end

    # GET /users/1
    def show
    end

    # GET /users/1/edit
    def edit
    end

    # PATCH /users/1
    def update
      respond_to do |format|
        if @user.update_attributes(user_params)
          format.html { redirect_to user_url(@user),
                        notice: 'User profile was successfully updated.' }
        else
          format.html { render action: "edit" }
        end
      end
    end

    # PUT /users/1/become
    def become
      sign_in(@user)
      redirect_to request.referrer, notice: "Logged in as #{@user.username}"
    end

    # PATCH /users/1/delete
    def delete
      @user.delete
      respond_to do |format|
        format.html { redirect_to request.referrer,
                                  notice: "#{@user.username}'s account has been disabled." }
        format.js { render 'admin/users/delete' }
      end
    end

    # PATCH /users/1/undelete
    def undelete
      @user.undelete
      respond_to do |format|
        format.html { redirect_to request.referrer,
                                  notice: "#{@user.username}'s account has been enabled." }
        format.js { render 'admin/users/delete' }
      end
    end

    protected

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :full_name, :title,
        :show_public_domain_attribution, :forward_emails_to_deputies,
        :receive_emails, :receive_collaborator_emails,
        :receive_list_emails, :receive_comment_emails)
    end

  end
end
