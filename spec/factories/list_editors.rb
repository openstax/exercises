# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :list_editor do
    list
    association :editor, factory: :user
  end
end
