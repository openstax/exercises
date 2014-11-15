FactoryGirl.define do
  factory :question do
    exercise
    stimulus { Faker::Lorem.paragraph }

    ignore do
      stems_count { stems.empty? ? 1 : 0 }
      answers_count { answers.empty? ? 3 : 0 }
    end

    after(:build) do |question, evaluator|
      evaluator.stems_count.times do
        question.stems << FactoryGirl.build(
          :stem, question: question,
                 stem_answers_count: evaluator.answers_count
        )
      end
    end
  end
end
