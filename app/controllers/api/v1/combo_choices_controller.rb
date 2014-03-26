module Api
  module V1

    class ComboChoicesController < OpenStax::Api::V1::ApiController

      resource_description do
        api_versions "v1"
        short_description 'TBD'
        description <<-EOS
          TBD
        EOS
      end

      api :GET, '/combo_choices/:id', 'Gets the specified Combo Choice'
      description <<-EOS
        #{json_schema(Api::V1::ComboChoiceRepresenter, include: :readable)}        
      EOS
      def show
        rest_get(ComboChoice, params[:id])
      end

      api :PUT, '/combo_choices/:id', 'Updates the specified Combo Choice'
      description <<-EOS
        Updates the Combo Choice object whose ID matches the provided param.
      EOS
      def update
        rest_update(ComboChoice, params[:id])
      end

      api :POST, '/combo_choices'
      def create
        question = Question.find(params[:multiple_choice_question_id])
        raise SecurityTransgression unless current_user.can_update?(question)
        result = CreateBlankComboChoice.call(question)

        if result.errors.none?
          choice = result.outputs[:combo_choice]
          respond_with choice
        else
          render json: result.errors, status: :unprocessable_entity
        end
      end

      api :DELETE, '/combo_choices/:id', 'Deletes the specified Combo Choice'
      def destroy
        rest_destroy(ComboChoice, params[:id])
      end
      
    end
  end
end