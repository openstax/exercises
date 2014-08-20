module Api::V1
  class AnswersController < OpenStax::Api::V1::ApiController

    resource_description do
      api_versions "v1"
      short_description 'Answers are ...'
      description <<-EOS
        Answers are ...
      EOS
    end

    api :GET, '/answers/:id', 'Gets the specified Answer'
    description <<-EOS
      #{json_schema(Api::V1::AnswerRepresenter, include: :readable)}        
    EOS
    def show
      rest_get(Answer, params[:id])
    end

    api :PUT, '/answers/:id', 'Updates the specified Answer'
    description <<-EOS
      Updates the Answer object whose ID matches the provided param.
    EOS
    def update
      rest_update(Answer, params[:id])
    end

    api :POST, '/answers'
    def create
      question = Question.find(params[:question_id])
      raise SecurityTransgression unless current_user.can_update?(question)
      result = CreateBlankSimpleChoice.call(question)

      if result.errors.none?
        choice = result.outputs[:answer]
        respond_with choice
      else
        render json: result.errors, status: :unprocessable_entity
      end
    end

    api :DELETE, '/answers/:id', 'Deletes the specified Answer'
    def destroy
      rest_destroy(Answer, params[:id])
    end

    api :PUT, '/answers/sort', 'Reorders a set of Answers'
    description <<-EOS
      <p>Changes the sort order of the specified Simple Choices.  Not all Simple Choices in 
      a Multiple Choice Question have to be specified in the request -- those whose positions
      are specified will be placed at those positions, and the rest of the choices in the
      question will be filled into the remaining spots in their original order.</p>

      <p>The request is formed as a list of pairings of Simple Choice ID and that choice's new
      zero-indexed position.</p>

      <p>Requirements:</p>

      * All of the specified Simple Choices must be from the same Multiple Choice Question.
      * The IDs must be unique (no repeats)
      * The positions must also be unique and valid for the number of Simple Choices in a
      given Multiple Choice Question

      #{json_schema(Api::V1::SortRepresenter, include: :writeable)}        
    EOS
    def sort
      standard_sort(Answer)
    end
    
  end
end
