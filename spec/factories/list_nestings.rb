FactoryBot.define do
  factory :list_nesting do
    association :parent_list, factory: :list
    association :child_list, factory: :list
  end
end
