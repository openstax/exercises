FactoryGirl.define do
  factory :stem do
    question
    content { Faker::Lorem.paragraph }

    transient do
      stem_answers_count { stem_answers.empty? ? 3 : 0 }
      styles [Style::FREE_RESPONSE]
    end

    after(:build) do |stem, evaluator|
      evaluator.stem_answers_count.times do
        stem.stem_answers << build(:stem_answer, stem: stem)
      end

      evaluator.styles.each do |style|
        stem.stylings << build(:styling, stylable: stem, style: style)
      end
    end
  end
end
