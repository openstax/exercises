FactoryGirl.define do
  factory :exercise do
    title { Faker::Lorem.words.join(' ').capitalize }
    stimulus { Faker::Lorem.paragraph }

    ignore do
      parts_count { parts.empty? ? 1 : 0 }
      questions_count 1
      items_count 0
      answers_count 4
    end

    after(:build) do |exercise, evaluator|
      exercise.publication = FactoryGirl.build(:publication, publishable: exercise)
      evaluator.parts_count.times do
        exercise.parts << FactoryGirl.build(
          :part, exercise: exercise, questions_count: evaluator.questions_count,
          items_count: evaluator.items_count, answers_count: evaluator.answers_count
        )
      end
    end

    trait :published do
      after(:build) do |exercise|
        exercise.publication.published_at = Time.now
      end
    end
  end
end
