module Api::V1
  class LibrariesController < OpenStax::Api::V1::ApiController

    resource_description do
      api_versions "v1"
      short_description 'A code Library'
      description <<-EOS
        A Library is a version-controlled piece of code reusable in Logics. 
      EOS
    end

    #########
    # index #
    #########

    api :GET, '/libraries', 'Gets a list of Libraries'
    description <<-EOS
      Gets a list of Libraries.

      #{json_schema(Api::V1::LibrarySearchRepresenter, include: :readable)}        
    EOS
    def index
      Library.all
    end

    ########
    # show #
    ########

    api :GET, '/libraries/:id', 'Gets the specified Library'
    description <<-EOS
      Gets the Library that matches the provided ID.

      #{json_schema(Api::V1::LibraryRepresenter, include: :readable)}        
    EOS
    def show
      standard_get(Library, params[:id])
    end

    ##########
    # create #
    ##########

    api :POST, '/libraries', 'Creates a new Library'
    description <<-EOS
      Creates a Library with the given attributes.

      #{json_schema(Api::V1::LibraryRepresenter, include: :writeable)}        
    EOS
    def create
      standard_create(Library)
    end

    ##########
    # update #
    ##########

    api :PUT, '/libraries/:id', 'Updates the specified Library'
    description <<-EOS
      Updates the Library that matches the provided ID with the given attributes.

      #{json_schema(Api::V1::LibraryRepresenter, include: :writeable)}        
    EOS
    def update
      standard_update(Library, params[:id])
    end

    ###########
    # destroy #
    ###########

    api :DELETE, '/libraries/:id', 'Deletes the specified Library'
    description <<-EOS
      Deletes the Library that matches the provided ID.    
    EOS
    def destroy
      standard_destroy(Library, params[:id])
    end
    
  end
end
