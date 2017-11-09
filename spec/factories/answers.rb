FactoryBot.define do
  factory :answer do
    question
    content { Faker::Lorem.paragraph }
  end
end
