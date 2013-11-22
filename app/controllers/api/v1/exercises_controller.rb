module Api
  module V1

    class ExercisesController < ApiController 

      resource_description do
        api_versions "v1"
        short_description 'APIs for Exercise objects'
        description <<-EOS
          Lorem ipsum dolor sit amet, consectetur 
          adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore 
            magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco 
            laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor 
            in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla 
            pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa 
            qui officia deserunt mollit anim id est laborum. 
        EOS
      end

      api :GET, '/exercise/:id', 'Lorem ipsum dolor sit amet'
      description <<-EOS
        Returns information about Lorem ipsum dolor sit amet, consectetur adipisicing 
        elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut 
          enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut 
          aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in 
          voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint 
          occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit 
          anim id est laborum
      EOS
      example <<-EOS
        { foo: bar }
      EOS
      def show
        @exercise = Exercise.find(params[:id])
        raise SecurityTransgression unless current_user.can_read?(@exercise)
      end

      def update

      end
      
    end
  end
end