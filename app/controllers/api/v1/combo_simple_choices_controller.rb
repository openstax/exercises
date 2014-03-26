module Api
  module V1

    class ComboSimpleChoicesController < OpenStax::Api::V1::ApiController 

      resource_description do
        api_versions "v1"
        short_description 'TBD'
        description <<-EOS
          TBD
        EOS
      end

      api :GET, '/combo_simple_choices/:id', 'Gets the specified Combo Simple Choice'
      description <<-EOS
        #{json_schema(Api::V1::ComboSimpleChoiceRepresenter, include: :readable)}        
      EOS
      def show
        rest_get(ComboSimpleChoice, params[:id])
      end

      api :POST, '/combo_simple_choices'
      def create
        combo_choice = ComboChoice.find(params[:combo_choice_id])
        raise SecurityTransgression unless current_user.can_update?(combo_choice)

        csc = ComboSimpleChoice.create do |csc|
          csc.combo_choice = combo_choice
          csc.simple_choice_id = params[:simple_choice_id]
        end

        if csc.errors.none?
          respond_with csc
        else
          render json: csc.errors, status: :unprocessable_entity
        end
      end

      api :DELETE, '/combo_simple_choices/:id', 'Deletes the specified Combo Simple Choice'
      def destroy
        rest_destroy(ComboSimpleChoice, params[:id])
      end
      
    end
  end
end