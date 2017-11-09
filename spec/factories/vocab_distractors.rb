FactoryBot.define do
  factory :vocab_distractor do
    after(:build) do |vocab_distractor, evaluator|
      vocab_distractor.vocab_term      ||= build(:vocab_term, vocab_distractors_count: 0)
      vocab_distractor.distractor_term ||= build(:vocab_term, vocab_distractors_count: 0)
    end
  end
end
