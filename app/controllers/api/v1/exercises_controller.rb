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
        respond_with @exercise
      end

      api :PUT, '/exercises/:id', 'Updates the specified Exercise'
      description <<-EOS
        Updates the Exercise object whose ID matches the provided param.  Any provided 
        transformed Content field (e.g. 'html') will be ignored.
      EOS
      example <<-EOS
        { 
          TBD maybe use mocks plus Api::V1::ExerciseRepresenter.new(Exercise.new).to_json
        }
      EOS
      def update
        @exercise = Exercise.find(params[:id])
        raise SecurityTransgression unless current_user.can_update?(@exercise)
        consume!(@exercise)
        
        if @exercise.save  #@exercise.update_attributes(params.slice(Exercise.accessible_attributes.to_a))
          head :no_content
        else
          render json: @exercise.errors, status: :unprocessable_entity
        end
      end
      
    end
  end
end