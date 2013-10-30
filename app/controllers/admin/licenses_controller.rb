module Admin
  class LicensesController < BaseController

    before_filter :get_license, only: [:show, :edit, :update, :destroy]

    def index
      @licenses = License.all
    end

    def new
      @license = License.new
    end

    def create
      @license = License.new(params[:license])

      respond_to do |format|
        if @license.save
          format.html { redirect_to admin_license_url(@license), notice: 'License was successfully created.' }
        else
          format.html { render action: "new" }
        end
      end
    end

    def update
      @license = License.find(params[:id])

      respond_to do |format|
        if @license.update_attributes(params[:license])
          format.html { redirect_to admin_license_url(@license), notice: 'License was successfully updated.' }
        else
          format.html { render action: "edit" }
        end
      end
    end

    def destroy
      @license.destroy
      redirect_to admin_licenses_url
    end

  protected

    def get_license
      @license = License.find(params[:id])
    end

  end
end
