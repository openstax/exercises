FactoryBot.define do
  factory :list_reader do
    list
    association :reader, factory: :user
  end
end
