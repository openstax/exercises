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
      def sort
        # take array of all IDs or hash of id => position,
        # regardless build up an array of all IDs in the right order and pass those to sort

        newPositions = params['newPositions']
        return head :no_content if newPositions.length == 0

        first = SimpleChoice.where(newPositions[0]).first

        return head :not_found if first.blank?


        originalOrdered = first.me_and_peers.ordered.all

        originalOrdered.each do |simple_choice|
          raise SecurityTransgression unless simple_choice.multiple_choice_question_id == originalOrdered[0].multiple_choice_question_id
          raise SecurityTransgression unless current_user.can_sort?(simple_choice)
        end

        originalOrderedIds = originalOrdered.collect{|sc| sc.id}


        newOrderedIds = Array.new(originalOrderedIds.size)

        newPositions.each do |id, position|
          id = id.to_i
          newOrderedIds[position] = id
          originalOrderedIds.delete(id)
        end

        ptr = 0
        for oldId in originalOrderedIds 
          while !newOrderedIds[ptr].nil?; ptr += 1; end
          newOrderedIds[ptr] = oldId
        end

        begin 
          SimpleChoice.sort!(newOrderedIds)
        rescue Exception => e
          return head :internal_server_error
        end

        head :no_content
      end
      
    end
  end
end