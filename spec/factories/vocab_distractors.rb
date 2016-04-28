FactoryGirl.define do
  factory :vocab_distractor do
    after(:build) do |vocab_distractor, evaluator|
      vocab_distractor.vocab_term      ||= build(:vocab_term, vocab_distractors_count: 0)
      vocab_distractor.distractor_publication ||= build(
        :vocab_term, :published, vocab_distractors_count: 0,
                                 distractor_literals: [Faker::Lorem.paragraph]
      ).publication
    end
  end
end
