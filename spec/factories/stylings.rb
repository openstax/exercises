FactoryGirl.define do
  factory :styling do
    association :stylable, factory: :solution
    style Style::FREE_RESPONSE
  end
end
