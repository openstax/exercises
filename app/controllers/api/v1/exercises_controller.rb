module Api
  module V1

    class ExercisesController < ApiController 

      resource_description do
        api_versions "v1"
        short_description 'Exercises are the containers for all information related to an exercise'
        description <<-EOS
          Exercises are ...
        EOS
      end

      api :GET, '/exercises/:id', 'Gets the specified Exercise'
      description <<-EOS
        #{json_schema(Api::V1::ExerciseRepresenter, include: :readable) if true}        
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

        #{json_schema(Api::V1::ExerciseRepresenter, include: :writeable)}        
      EOS
      def update
        @exercise = Exercise.find(params[:id])
        raise SecurityTransgression unless current_user.can_update?(@exercise)
        consume!(@exercise)
        
        if @exercise.save
          head :no_content
        else
          render json: @exercise.errors, status: :unprocessable_entity
        end
      end
      
    end
  end
end