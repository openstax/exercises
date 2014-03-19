# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :library do
    language 1
    name "MyString"
    summary "MyText"
    is_prerequisite false
    owner_id 1
  end
end
