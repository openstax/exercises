FactoryGirl.define do
  factory :question do
    exercise
    stimulus { Faker::Lorem.paragraph }

    ignore do
      stems_count { stems.empty? ? 1 : 0 }
      answers_count { answers.empty? ? 1 : 0 }
    end

    after(:build) do |question, evaluator|
      evaluator.questions_count.times do
        question.stems << FactoryGirl.build(
          :stem, question: question
        )
      end

      evaluator.answers_count.times do
        question.answers << FactoryGirl.build(
          :answer, question: question
        )
      end
    end
  end
end
