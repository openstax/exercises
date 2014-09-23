module Api
  module V1

    class LibraryVersionsController < OpenStax::Api::V1::ApiController 

      resource_description do
        api_versions "v1"
        short_description 'A version of the code for a Library'
        description <<-EOS
          A Library is a version-controlled resource.  LibraryVersions are the realization of
          those versions.  They contain the libraries code for a particular version.  
        EOS
      end

      api :GET, '/library_versions/:id', 'Gets the specified LibraryVersion'
      description <<-EOS        
      EOS
      def show
        rest_get(LibraryVersion, params[:id])
      end

      api :PUT, '/library_versions/:id', 'Updates the specified LibraryVersion'
      description <<-EOS
        Updates the LibraryVersion object whose ID matches the provided param.
      EOS
      def update
        rest_update(LibraryVersion, params[:id])
      end

      api :POST, '/library_versions', 'Creates a new LibraryVersion with the specified parameters'
      def create
        rest_create(LibraryVersion)
      end

      api :DELETE, '/library_versions/:id', 'Deletes the specified LibraryVersion'
      def destroy
        rest_destroy(LibraryVersion, params[:id])
      end

      api :GET, '/library_versions/digest', 'Returns the concatenation of the specified LibraryVersions in the given order'
      def digest
        ids = (params[:ids] || '').split(',')
        
        # Get the models
        @versions = LibraryVersion.where{id.in ids}.all

        raise SecurityTransgression unless @versions.all?{|version| current_user.can_read?(version)}

        # freak out if the number of models doesn't match the number of IDs
        if @versions.length != ids.length
          render json: { errors: 'You requested some library versions that could not be found' }, status: :not_found
        end

        # TODO freak out if the models are from different languages

        render json: {code: @versions.collect{|vv| vv.code}.join("\n\n"), ids: ids, }
      end

      api :GET, '/library_versions', 'Returns the specified LibraryVersions in the given order'
      def index

      end
      
    end
  end
end