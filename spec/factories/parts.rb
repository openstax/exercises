FactoryGirl.define do
  factory :part do
    exercise
    background { Faker::Lorem.paragraph }

    ignore do
      questions_count { questions.empty? ? 1 : 0 }
      items_count 0
      answers_count 4
    end

    after(:build) do |part, evaluator|
      evaluator.questions_count.times do
        part.questions << FactoryGirl.build(
          :question, part: part,
          items_count: evaluator.items_count, answers_count: evaluator.answers_count
        )
      end
    end
  end
end
