module Admin
  class ClassLicensesController < BaseController
    before_action :set_class_license, only: [:show, :edit, :update, :destroy]

    # GET /class_licenses
    def index
      @class_licenses = ClassLicense.all
    end

    # GET /class_licenses/1
    def show
    end

    # GET /class_licenses/new
    def new
      @class_license = ClassLicense.new
    end

    # GET /class_licenses/1/edit
    def edit
    end

    # POST /class_licenses
    def create
      @class_license = ClassLicense.new(class_license_params)

      if @class_license.save
        redirect_to @class_license, notice: 'Class license was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /class_licenses/1
    def update
      if @class_license.update(class_license_params)
        redirect_to @class_license, notice: 'Class license was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /class_licenses/1
    def destroy
      @class_license.destroy
      redirect_to class_licenses_url, notice: 'Class license was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_class_license
        @class_license = ClassLicense.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def class_license_params
        params.require(:class_license).permit(:license_id, :class_name)
      end
  end
end
