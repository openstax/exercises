FactoryBot.define do
  factory :list_editor do
    list
    association :editor, factory: :user
  end
end
