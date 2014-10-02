FactoryGirl.define do
  factory :item do
    question
    content { Faker::Lorem.paragraph }
  end
end
