module Api
  module V1

    class LogicsController < ApiController 

      resource_description do
        api_versions "v1"
        short_description 'Blocks of code used to make dynamically-generated variations of Exercises and Solutions'
      end

      api :GET, '/logics/:id', 'Gets the specified Logic'
      description <<-EOS
        #{json_schema(Api::V1::LogicRepresenter, include: :readable)}        
      EOS
      def show
        rest_get(Logic, params[:id])
      end

      api :PUT, '/logics/:id', 'Updates the specified Logic'
      description <<-EOS
        Updates the Logic object whose ID matches the provided param.
      EOS
      def update
        rest_update(Logic, params[:id])
      end

      api :POST, '/logics', 'Creates a new Logic with the specified parameters'
      def create
        rest_create(Logic)
      end

      api :DELETE, '/logics/:id', 'Deletes the specified Logic'
      def destroy
        rest_destroy(Logic, params[:id])
      end
      
    end
  end
end