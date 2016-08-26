module Api::V1
  class QuestionDependencyRepresenter < Roar::Decorator

    include Roar::JSON

    property :parent_question_id,
             type: Integer,
             writeable: true,
             readable: true,
             setter: ->(input:, **) do
               self.parent_question = dependent_question.exercise.questions
                                        .find{ |ans| (ans.id || ans.temp_id) == input }
             end

    property :is_optional,
             as: :optional,
             writeable: true,
             readable: true,
             schema_info: {
               required: true,
               type: 'boolean'
             }

  end
end
