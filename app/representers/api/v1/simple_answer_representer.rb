module Api::V1
  class SimpleAnswerRepresenter < Roar::Decorator

    include Roar::JSON

    can_view_solutions_proc = ->(user_options:, **) do
      user_options[:can_view_solutions] = \
        question.exercise.can_view_solutions?(user_options[:user]) \
        if user_options[:can_view_solutions].nil?

      user_options[:can_view_solutions]
    end

    property :id,
             type: Integer,
             writeable: false,
             readable: true

    property :content,
             as: :content_html,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

    property :correctness,
             type: Float,
             writeable: true,
             readable: true,
             if: can_view_solutions_proc,
             getter: ->(*) do
              stem_answers << StemAnswer.new(answer: self, stem: question.stems.first) \
                if stem_answers.empty?

               stem_answers.first.correctness
             end,
             setter: ->(input:, **) do
              stem_answers << StemAnswer.new(answer: self, stem: question.stems.first) \
                if stem_answers.empty?

              stem_answers.first.correctness = input
             end,
             schema_info: {
               type: 'number'
             }

    property :feedback,
             as: :feedback_html,
             type: String,
             writeable: true,
             readable: true,
             if: can_view_solutions_proc,
             getter: ->(*) do
               stem_answers << StemAnswer.new(answer: self, stem: question.stems.first) \
                 if stem_answers.empty?

               stem_answers.first.feedback
             end,
             setter: ->(input:, **) do
               stem_answers << StemAnswer.new(answer: self, stem: question.stems.first) \
                 if stem_answers.empty?

               stem_answers.first.feedback = input
             end

  end
end
