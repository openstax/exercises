module Admin
  class LibrariesController < BaseController

    before_filter :get_library, only: [:show, :edit, :update, :destroy]

    def index
      @libraries = Library.order{name.asc}
    end

    def show; end

    def new
      @library = Library.new
    end

    def edit; end

    def create
      @library = Library.new(params[:library])
  
      if @library.save
        redirect_to([:admin, @library], :notice => 'Library was successfully created.')
      else
        render :action => "new"
      end      
    end

    def update
      @library = Library.find(params[:id])

      if @library.update_attributes(params[:library])
        redirect_to([:admin, @library], :notice => 'Logic library was successfully updated.')
      else
        render :action => "edit"
      end
    end

    def destroy
      if @library.destroy
        redirect_to(admin_logic_libraries_url)
      else
        @errors = @library.errors
        render :action => 'show'
      end
    end

  protected

    def get_library
      @library = Library.find(params[:id])
    end
    
  end
end
