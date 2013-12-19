module Api
  module V1

    class SimpleChoicesController < ApiController 

      resource_description do
        api_versions "v1"
        short_description 'TBD'
        description <<-EOS
          TBD
        EOS
      end

      api :GET, '/simple_choices/:id', 'Gets the specified Simple Choice'
      description <<-EOS
        #{json_schema(Api::V1::SimpleChoiceRepresenter, include: :readable)}        
      EOS
      def show
        rest_get(SimpleChoice, params[:id])
      end

      api :PUT, '/simple_choices/:id', 'Updates the specified Simple Choice'
      description <<-EOS
        Updates the Simple Choice object whose ID matches the provided param.
      EOS
      def update
        rest_update(SimpleChoice, params[:id])
      end

      api :POST, '/simple_choices'
      def create
        question = Question.find(params[:multiple_choice_question_id])
        raise SecurityTransgression unless current_user.can_update?(question)
        result = CreateBlankSimpleChoice.call(question)

        if result.errors.none?
          choice = result.outputs[:simple_choice]
          respond_with choice
        else
          render json: result.errors, status: :unprocessable_entity
        end
      end

      api :DELETE, '/simple_choices/:id', 'Deletes the specified Simple Choice'
      def destroy
        rest_destroy(SimpleChoice, params[:id])
      end
      
    end
  end
end