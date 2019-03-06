FactoryBot.define do
  factory :exercise do
    title { Faker::Lorem.words.join(' ').capitalize }
    stimulus { Faker::Lorem.paragraph }

    transient do
      questions_count { questions.empty? ? 1 : 0 }
      stems_count { 1 }
      answers_count { 3 }
      collaborator_solutions_count { 1 }
    end

    after(:build) do |exercise, evaluator|
      evaluator.questions_count.times do
        exercise.questions << build(:question, exercise: exercise,
                                    stems_count: evaluator.stems_count,
                                    answers_count: evaluator.answers_count,
                                    collaborator_solutions_count: evaluator.collaborator_solutions_count)
      end
    end

    trait :published do
      after(:build) do |exercise|
        exercise.publication.publish
      end
    end
  end
end
