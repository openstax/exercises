FactoryBot.define do
  factory :stem_answer do
    stem
    answer do
      build(:answer, question: stem.question).tap { |answer| stem.question.answers << answer }
    end
    feedback { '<p>Some feedback</p>' }
  end
end
