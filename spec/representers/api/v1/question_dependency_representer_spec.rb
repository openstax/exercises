module Api::V1
  class QuestionDependencyRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :parent_question_id,
             type: Integer,
             writeable: true,
             readable: true,
             setter: lambda { |val|
               self.parent_question = dependent_question.exercise.questions
                                        .select{ |i|
                                          (i.id || i.temp_id) == val
                                        }.first
             }

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
