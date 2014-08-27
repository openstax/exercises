module Admin
  class LicenseCompatibilitiesController < BaseController

    before_filter :get_license_compatibility, only: [:show, :edit, :update, :destroy]

    def index
      @license_compatibilities = LicenseCompatibility.all
    end

    def new
      @license_compatibility = LicenseCompatibility.new
    end

    def create
      @license_compatibility = LicenseCompatibility.new(params[:license_compatibility])

      respond_to do |format|
        if @license_compatibility.save
          format.html { redirect_to admin_license_compatibility_url(@license_compatibility), notice: 'LicenseCompatibility was successfully created.' }
        else
          format.html { render action: "new" }
        end
      end
    end

    def update
      @license_compatibility = LicenseCompatibility.find(params[:id])

      respond_to do |format|
        if @license_compatibility.update_attributes(params[:license_compatibility])
          format.html { redirect_to admin_license_compatibility_url(@license_compatibility), notice: 'LicenseCompatibility was successfully updated.' }
        else
          format.html { render action: "edit" }
        end
      end
    end

    def destroy
      @license_compatibility.destroy
      redirect_to admin_license_compatibilitys_url
    end

  protected

    def get_license_compatibility
      @license_compatibility = LicenseCompatibility.find(params[:id])
    end

  end
end
