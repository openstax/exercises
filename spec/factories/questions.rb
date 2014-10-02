FactoryGirl.define do
  factory :question do
    part
    stem { Faker::Lorem.paragraph }

    ignore do
      items_count 0
      answers_count { answers.empty? ? 4 : 0 }
    end

    after(:build) do |question, evaluator|
      evaluator.items_count.times do
        question.items << FactoryGirl.build(:item, question: question)
      end

      evaluator.answers_count.times do
        question.answers << FactoryGirl.build(:answer, question: question)
      end
    end
  end
end
