module Admin
  class TrustedApplicationsController < BaseController

    respond_to :html

    # GET /trusted_applications
    def index
      @trusted_applications = TrustedApplication.all
      @applications = Doorkeeper::Application.not_trusted
    end

    # POST /trusted_applications
    def create
      @trusted_application = TrustedApplication.new(trusted_application_params)

      @trusted_application.save!
      redirect_to admin_trusted_applications_url,
                  notice: "#{@trusted_application.application.name || '---'} is now a trusted application."
    end

    # DELETE /trusted_applications/1
    def destroy
      @trusted_application = TrustedApplication.find(params[:id])
      @trusted_application.destroy
      redirect_to admin_trusted_applications_url,
                  notice: "#{@trusted_application.application.name || '---'} is no longer a trusted application."
    end

    protected

    # Only allow a trusted parameter "white list" through.
    def trusted_application_params
      params.require(:trusted_application).permit(:application_id)
    end

  end
end
