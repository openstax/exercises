FactoryGirl.define do
  factory :stem_answer do
    stem
    answer { build(:answer, question: stem.question) }
    feedback '<p>Some feedback</p>'
  end
end
