module Api::V1
  class ComboChoiceAnswersController < OpenStax::Api::V1::ApiController

    resource_description do
      api_versions "v1"
      short_description 'ComboChoiceAnswers are ...'
      description <<-EOS
        ComboChoiceAnswers are ...
      EOS
    end

    api :GET, '/combo_choice_answers/:id', 'Gets the specified Combo Choice Answer'
    description <<-EOS
      #{json_schema(Api::V1::ComboChoiceAnswerRepresenter, include: :readable)}        
    EOS
    def show
      rest_get(ComboChoiceAnswer, params[:id])
    end

    api :POST, '/combo_choice_answers'
    def create
      combo_choice = ComboChoice.find(params[:combo_choice_id])
      raise SecurityTransgression unless current_user.can_update?(combo_choice)

      csc = ComboChoiceAnswer.create do |csc|
        csc.combo_choice = combo_choice
        csc.simple_choice_id = params[:simple_choice_id]
      end

      if csc.errors.none?
        respond_with csc
      else
        render json: csc.errors, status: :unprocessable_entity
      end
    end

    api :DELETE, '/combo_choice_answers/:id', 'Deletes the specified Combo Choice Answer'
    def destroy
      rest_destroy(ComboChoiceAnswer, params[:id])
    end
    
  end
end
