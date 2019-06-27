module Admin
  class LicensesController < BaseController

    before_action :set_license, only: [:show, :edit, :update, :destroy]

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

      if @license.save
        redirect_to admin_license_url(@license),
                    notice: 'License was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /licenses/1
    def update
      if @license.update(license_params)
        redirect_to admin_license_url(@license),
                    notice: 'License was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /licenses/1
    def destroy
      @license.destroy
      redirect_to admin_licenses_url, notice: 'License was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_license
      @license = License.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def license_params
      params.require(:license).permit(
        :name, :title, :url, :publishing_contract, :copyright_notice, :requires_attribution,
        :requires_share_alike, :allows_derivatives, :allows_commercial_user
      )
    end

  end
end
