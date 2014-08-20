module Api::V1
  class LibrariesController < OpenStax::Api::V1::ApiController

    resource_description do
      api_versions "v1"
      short_description 'A code Library'
      description <<-EOS
        A Library is a version-controlled piece of code reusable in Logics. 
      EOS
    end

    api :GET, '/libraries/:id', 'Gets the specified Library'
    description <<-EOS
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
