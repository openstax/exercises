module Admin
  class AdministratorsController < BaseController

    # GET /administrators
    def index
      @administrators = Administrator.all
    end

    # GET /administrators/new
    def new
      handle_with(Admin::UsersIndex,
                  complete: lambda { render 'users/index' })
    end

    # POST /administrators
    def create
      @administrator = Administrator.new(administrator_params)

      respond_to do |format|
        if @administrator.save
          format.html {
            redirect_to admin_administrators_url,
              notice: "#{@administrator.user.full_name} is now an Administrator." }
        else
          format.html { render action: "new" }
        end
      end
    end

    # DELETE /administrators/1
    def destroy
      @administrator = Administrator.find(params[:id])
      @administrator.destroy
      redirect_to admin_administrators_url
    end

    private

    # Only allow a trusted parameter "white list" through.
    def administrator_params
      params.require(:administrator).permit(:user_id)
    end

  end
end
