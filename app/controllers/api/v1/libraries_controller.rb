module Api
  module V1

    class LibrariesController < ApiController 

      resource_description do
        api_versions "v1"
        short_description 'A version of the code for a Library'
        description <<-EOS
          A Library is a version-controlled resource.  Libraries are the realization of
          those versions.  They contain the libraries code for a particular version.  
        EOS
      end

      api :GET, '/libraries/:id', 'Gets the specified Library'
      description <<-EOS
        #{json_schema(Api::V1::LibraryRepresenter, include: :readable)}        
      EOS
      def show
        rest_get(Library, params[:id])
      end

      api :PUT, '/libraries/:id', 'Updates the specified Library'
      description <<-EOS
        Updates the Library object whose ID matches the provided param.
      EOS
      def update
        rest_update(Library, params[:id])
      end

      api :POST, '/libraries', 'Creates a new Library with the specified parameters'
      def create
        rest_create(Library)
      end

      api :DELETE, '/libraries/:id', 'Deletes the specified Library'
      def destroy
        rest_destroy(Library, params[:id])
      end
      
    end
  end
end