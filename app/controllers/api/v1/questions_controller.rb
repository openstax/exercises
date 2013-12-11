module Api
  module V1

    class QuestionsController < ApiController 

      resource_description do
        api_versions "v1"
        short_description 'TBD'
        description <<-EOS
          TBD
        EOS
      end

      api :GET, '/questions/:id', 'Gets the specified Question'
      description <<-EOS
        #{json_schema(Api::V1::MultipleChoiceQuestionRepresenter, include: :readable)}        
      EOS
      def show
        raise NotYetImplemented
        # rest_get(Question, params[:id])
      end

      api :PUT, '/questions/:id', 'Updates the specified Question'
      description <<-EOS
        Updates the Question object whose ID matches the provided param.

        
      EOS
      def update
        raise NotYetImplemented
        # rest_update(Question, params[:id])
      end

      api :POST, '/questions'
      def create
        part = Part.find(params[:part_id])
        raise SecurityTransgression unless current_user.can_update?(part)
        result = CreateBlankQuestion.call(part, params[:type])

        if result.errors.none?
          respond_with result.outputs[:question]
        else
          render json: result.errors, status: :unprocessable_entity
        end
      end
      
    end
  end
end