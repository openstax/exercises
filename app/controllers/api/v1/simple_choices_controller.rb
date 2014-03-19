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

      api :PUT, '/simple_choices/sort', 'Reorders a set of Simple Choices'
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
        standard_sort(SimpleChoice)
      end
      
    end
  end
end