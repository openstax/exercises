module Admin
  class AdministratorsController < BaseController

    # GET /administrators
    def index
      @administrators = Administrator.all
      handle_with Admin::UsersSearch
    end

    # POST /administrators
    def create
      @administrator = Administrator.new(administrator_params)

      respond_to do |format|
        if @administrator.save
          format.html do
            redirect_to admin_administrators_url,
                        notice: "#{@administrator.user.name} is now an Administrator."
          end
        else
          format.html { render action: "new" }
        end
      end
    end

    # DELETE /administrators/1
    def destroy
      @administrator = Administrator.find(params[:id])
      @administrator.destroy
      respond_to do |format|
        format.html do
          redirect_to admin_administrators_url,
                      notice: "#{@administrator.user.name} is no longer an Administrator."
        end
      end
    end

    private

    # Only allow a trusted parameter "white list" through.
    def administrator_params
      params.require(:administrator).permit(:user_id)
    end

  end
end
