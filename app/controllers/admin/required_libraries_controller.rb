module Admin
  class RequiredLibrariesController < ApplicationController
    before_action :set_required_library, only: [:show, :edit, :update, :destroy]

    # GET /required_libraries
    def index
      @required_libraries = RequiredLibrary.all
    end

    # GET /required_libraries/1
    def show
    end

    # GET /required_libraries/new
    def new
      @required_library = RequiredLibrary.new
    end

    # GET /required_libraries/1/edit
    def edit
    end

    # POST /required_libraries
    def create
      @required_library = RequiredLibrary.new(required_library_params)

      if @required_library.save
        redirect_to @required_library, notice: 'Required library was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /required_libraries/1
    def update
      if @required_library.update(required_library_params)
        redirect_to @required_library, notice: 'Required library was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /required_libraries/1
    def destroy
      @required_library.destroy
      redirect_to required_libraries_url, notice: 'Required library was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_required_library
        @required_library = RequiredLibrary.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def required_library_params
        params.require(:required_library).permit(:library_id)
      end
  end
end
