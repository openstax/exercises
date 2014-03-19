# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :logic do
    code "MyText"
    variables "MyString"
    logicable_type "MyString"
    logicable_id 1
  end
end
