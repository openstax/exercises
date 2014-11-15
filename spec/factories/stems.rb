FactoryGirl.define do
  factory :stem do
    question
    content { Faker::Lorem.paragraph }

    ignore do
      stem_answers_count { stem_answers.empty? ? 3 : 0 }
    end

    after(:build) do |stem, evaluator|
      evaluator.stem_answers_count.times do
        stem.stem_answers << FactoryGirl.build(:stem_answer, stem: stem)
      end
    end
  end
end
