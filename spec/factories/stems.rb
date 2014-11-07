FactoryGirl.define do
  factory :stem do
    question
    content { Faker::Lorem.paragraph }
  end
end
