module Api::V1::Exercises
  class QuestionDependencyRepresenter < BaseRepresenter

    property :parent_question_id,
             type: Integer,
             writeable: true,
             readable: true,
             setter: ->(options) do
               self.parent_question = dependent_question.exercise.questions
                                        .find { |qq| (qq.id || qq.temp_id) == options[:input] }
             end

    property :is_optional,
             writeable: true,
             readable: true,
             schema_info: {
               required: true,
               type: 'boolean'
             }

  end
end
