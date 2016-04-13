FactoryGirl.define do
  factory :distractor do
    after(:build) do |distractor, evaluator|
      distractor.term            ||= build(:term, distractors_count: 0)
      distractor.distractor_term ||= build(:term, distractors_count: 0)
    end
  end
end
