FactoryBot.define do
  factory :publication_group do
    publishable_type     { 'Exercise' }
    latest_version       { 1 }
    solutions_are_public { [ true, false ].sample }
  end
end
