module Admin
  class LibraryVersionsController < BaseController

    before_filter :get_library, only: [:new, :create]
    before_filter :get_library_version, only: [:show, :edit, :update, :destroy]
  
    def show; end

    def new
     @library_version = LibraryVersion.new(:library_id => @library.id)
    end

    def edit; end

    def create
      @library_version = LibraryVersion.new(params[:library_version])
      @library_version.library = @library

      if @library_version.save
        redirect_to([:admin, @library_version], :notice => 'Library version was successfully created.')
      else
        render :action => "new"
      end
    end
    
    def update
      if @library_version.update_attributes(params[:library_version])
        redirect_to([:admin, @library_version], :notice => 'Library version was successfully updated.')
      else
        render :action => "edit"
      end
    end

    def destroy
      if @library_version.destroy
        redirect_to([:admin, @library_version.library])
      else
        @errors = @library_version.errors
        render :action => 'show'
      end
    end
    
  protected
  
    def get_library
      @library = Library.find(params[:library_id])
    end

    def get_library_version
      @library_version = LibraryVersion.find(params[:id])
    end

  end
end