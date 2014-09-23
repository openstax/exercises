module Admin
  class RequiredLibrariesController < BaseController

    respond_to :html

    # GET /required_libraries
    def index
      @required_libraries = RequiredLibrary.all
      @libraries = Library.not_required
    end

    # POST /required_libraries
    def create
      @required_library = RequiredLibrary.new(required_library_params)

      @required_library.save!
      redirect_to admin_required_libraries_url,
                  notice: "#{@required_library.library.name || '---'} is now a required library."
    end

    # DELETE /required_libraries/1
    def destroy
      @required_library = RequiredLibrary.find(params[:id])
      @required_library.destroy
      redirect_to admin_required_libraries_url,
                  notice: "#{@required_library.library.name || '---'} is no longer a required library."
    end

    protected

    # Only allow a trusted parameter "white list" through.
    def required_library_params
      params.require(:required_library).permit(:library_id)
    end

  end
end
