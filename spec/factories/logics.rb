FactoryBot.define do
  factory :logic do
    association :parent, factory: :exercise
    language { 'javascript' }
    code { Faker::Lorem.paragraph }
  end
end
