FactoryGirl.define do
  factory :answer do
    question
    content { Faker::Lorem.paragraph }

    after(:build) do |answer|
      answer.item ||= answer.question.items.sample
    end
  end
end
