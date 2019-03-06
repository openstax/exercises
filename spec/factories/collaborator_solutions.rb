FactoryBot.define do
  factory :collaborator_solution do
    question
    solution_type { SolutionType::EXAMPLE }
    content { "Worked example!" }
  end
end
