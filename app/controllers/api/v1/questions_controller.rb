module Api
  module V1

    class QuestionsController < OpenStax::Api::V1::ApiController 

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
        rest_get(Question, params[:id], QuestionRepresenter.method(:sub_representer_for).to_proc)
      end

      api :PUT, '/questions/:id', 'Updates the specified Question'
      description <<-EOS
        Updates the Question object whose ID matches the provided param.

        
      EOS
      def update
        rest_update(Question, params[:id], QuestionRepresenter.method(:sub_representer_for).to_proc)
      end

      api :POST, '/questions'
      def create
        part = Part.find(params[:part_id])
        raise SecurityTransgression unless current_user.can_update?(part)
        result = CreateBlankQuestion.call(part, params[:type])

        if result.errors.none?
          question = result.outputs[:question]
          respond_with question, represent_with: QuestionRepresenter.sub_representer_for(question)
        else
          render json: result.errors, status: :unprocessable_entity
        end
      end

      api :DELETE, '/questions/:id', 'Deletes the specified Question'
      def destroy
        rest_destroy(Question, params[:id])
      end
      
    end
  end
end