module Admin
  class FormatsController < BaseController

    before_action :set_format, only: [:show, :edit, :update, :destroy]

    # GET /formats
    def index
      @formats = Format.all
    end

    # GET /formats/1
    def show
    end

    # GET /formats/new
    def new
      @format = Format.new
    end

    # GET /formats/1/edit
    def edit
    end

    # POST /formats
    def create
      @format = Format.new(format_params)

      if @format.save
        redirect_to admin_format_url(@format),
                    notice: 'Format was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /formats/1
    def update
      if @format.update(format_params)
        redirect_to admin_format_url(@format),
                    notice: 'Format was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /formats/1
    def destroy
      @format.destroy
      redirect_to admin_formats_url, notice: 'Format was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_format
      @format = Format.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def format_params
      params.require(:format).permit(:name, :description)
    end

  end
end
