FactoryBot.define do
  factory :list_owner do
    list
    association :owner, factory: :user
  end
end
