FactoryBot.define do
  factory :stem do
    question
    content { Faker::Lorem.paragraph }

    transient do
      stem_answers_count { stem_answers.empty? ? 3 : 0 }
      styles { [Style::FREE_RESPONSE] }
    end

    after(:build) do |stem, evaluator|
      sas = evaluator.stem_answers_count.times.map do
        stem.stem_answers << build(:stem_answer, stem: stem)
      end

      stem.stem_answers.sample.correctness = 1.0 \
        if !stem.stem_answers.empty? && stem.stem_answers.none?{ |sa| sa.is_correct? }

      evaluator.styles.each do |style|
        stem.stylings << build(:styling, stylable: stem, style: style)
      end
    end
  end
end
