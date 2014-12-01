FactoryGirl.define do
  factory :list do
    name { Faker::Lorem.words.join(' ').capitalize }

    ignore do
      list_exercises_count { list_exercises.empty? ? 5 : 0 }
    end

    after(:build) do |list, evaluator|
      evaluator.list_exercises_count.times do
        list.list_exercises << build(:list_exercise, list: list)
      end
    end
  end
end
