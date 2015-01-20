FactoryGirl.define do
  factory :solution do
    question
    solution_type SolutionType::EXAMPLE
    content "Worked example!"
  end
end
