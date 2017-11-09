FactoryBot.define do
  factory :vocab_term do
    name                { Faker::Lorem.words.join(' ').capitalize }
    definition          { Faker::Lorem.paragraph }
    distractor_literals { [] }

    transient { vocab_distractors_count { vocab_distractors.empty? ? 2 : 0 } }

    after(:build) do |vocab_term, evaluator|
      evaluator.vocab_distractors_count.times do
        vocab_term.vocab_distractors << build(:vocab_distractor, vocab_term: vocab_term)
      end
    end

    trait(:published) { after(:build) { |vocab_term| vocab_term.publication.publish } }
  end
end
