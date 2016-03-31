module Api::V1
  class StemAnswerRepresenter < Roar::Decorator

    include Roar::JSON

    property :answer_id,
             type: Integer,
             writeable: true,
             readable: true,
             setter: lambda { |val, *|
               self.answer = stem.question.answers.select{|i| (i.id || i.temp_id) == val}.first
             },
             getter: lambda { |*| answer.id || answer.temp_id! },
             schema_info: {
               required: true
             }

    property :correctness,
             type: Float,
             writeable: true,
             readable: true,
             skip_render: lambda { |represented, args|
               !stem.question.exercise.can_view_solutions?(args[:user])
             },
             schema_info: {
               type: 'number'
             }

    property :feedback,
             as: :feedback_html,
             type: String,
             writeable: true,
             readable: true,
             skip_render: lambda { |represented, args|
               !stem.question.exercise.can_view_solutions?(args[:user])
             }

  end
end
