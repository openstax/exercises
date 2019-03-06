FactoryBot.define do
  factory :community_solution do
    question
    solution_type { SolutionType::EXAMPLE }
    content { "Worked example!" }

    after(:build) do |solution, evaluator|
      solution.publication ||= build(:publication, publishable: solution)
    end

    trait :published do
      after(:build) do |solution|
        solution.publication.publish
      end
    end
  end
end
