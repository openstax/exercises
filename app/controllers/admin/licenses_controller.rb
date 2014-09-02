module Admin
  class LicensesController < BaseController

    before_filter :set_license, only: [:show, :edit, :update, :destroy]

    # GET /licenses
    def index
      @licenses = License.all
    end

    # GET /licenses/1
    def show
    end

    # GET /licenses/new
    def new
      @license = License.new
    end

    # GET /licenses/1/edit
    def edit
    end

    # POST /licenses
    def create
      @license = License.new(license_params)

      respond_to do |format|
        if @license.save
          format.html { redirect_to admin_license_url(@license), notice: 'License was successfully created.' }
        else
          format.html { render action: "new" }
        end
      end
    end

    # PATCH /licenses/1
    def update
      @license = License.find(params[:id])

      respond_to do |format|
        if @license.update_attributes(license_params)
          format.html { redirect_to admin_license_url(@license), notice: 'License was successfully updated.' }
        else
          format.html { render action: "edit" }
        end
      end
    end

    # DELETE /licenses/1
    def destroy
      @license.destroy
      redirect_to admin_licenses_url
    end

    protected

    # Use callbacks to share common setup or constraints between actions.
    def set_license
      @license = License.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def license_params
      params.require(:license).permit(:name, :short_name, :url,
        :publishing_contract, :copyright_notice, :is_public_domain)
    end

  end
end
