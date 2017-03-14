module Api::V1
  class StemAnswerRepresenter < Roar::Decorator

    include Roar::JSON

    can_view_solutions_proc = ->(user_options:, **) do
      user_options[:can_view_solutions] ||=
        user_options.has_key?(:can_view_solutions) ?
          user_options[:can_view_solutions] :
          stem.question.exercise.can_view_solutions?(user_options[:user])
    end

    property :answer_id,
             type: Integer,
             writeable: true,
             readable: true,
             setter: ->(input:, **) do
               self.answer = question.answers.find{ |ans| (ans.id || ans.temp_id) == input }
             end,
             schema_info: {
               required: true
             }

    property :correctness,
             type: Float,
             writeable: true,
             readable: true,
             if: can_view_solutions_proc,
             schema_info: {
               type: 'number'
             }

    property :feedback,
             as: :feedback_html,
             type: String,
             writeable: true,
             readable: true,
             if: can_view_solutions_proc

  end
end
