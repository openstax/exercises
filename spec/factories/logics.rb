FactoryGirl.define do
  factory :logic do
    association :parent, factory: :exercise
    language 'javascript'
  end
end
