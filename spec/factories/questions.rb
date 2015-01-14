FactoryGirl.define do
  factory :question do
    exercise
    stimulus { Faker::Lorem.paragraph }

    transient do
      stems_count { stems.empty? ? 1 : 0 }
      answers_count { answers.empty? ? 3 : 0 }
    end

    after(:build) do |question, evaluator|
      evaluator.stems_count.times do
        stem = build(:stem, question: question, stem_answers_count: 0)
        question.stems << stem
        evaluator.answers_count.times do
          answer = build(:answer, question: question)
          question.answers << answer
          stem_answer = build(:stem_answer, stem: stem, answer: answer)
          stem.stem_answers << stem_answer
          answer.stem_answers << stem_answer
        end
      end
    end
  end
end
