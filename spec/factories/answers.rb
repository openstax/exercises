FactoryBot.define do
  factory :answer do
    question
    content { Faker::Lorem.paragraph }

    after(:create) do |answer|
      if answer.stem_answers.empty?
        stem = answer.question.stems.first
        stem_answer = build :stem_answer, stem: stem, answer: answer
        stem.stem_answers << stem_answer
        answer.stem_answers << stem_answer
      end
    end
  end
end
