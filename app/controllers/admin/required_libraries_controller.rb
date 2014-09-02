module Admin
  class RequiredLibrariesController < BaseController

    # GET /required_libraries
    def index
      @required_libraries = RequiredLibrary.all
    end

    # GET /required_libraries/new
    def new
      @published_libraries = Library.published
    end

    # POST /required_libraries
    def create
      @required_library = RequiredLibrary.new(required_library_params)

      respond_to do |format|
        if @required_library.save
          format.html { redirect_to admin_required_library_url(@required_library), notice: 'RequiredLibrary was successfully created.' }
        else
          format.html { render action: "new" }
        end
      end
    end

    # DELETE /required_libraries/1
    def destroy
      @required_library = RequiredLibrary.find(params[:id])
      @required_library.destroy
      redirect_to admin_required_libraries_url
    end

    protected

    # Only allow a trusted parameter "white list" through.
    def required_library_params
      params.require(:required_library).permit(:library_id)
    end

  end
end
