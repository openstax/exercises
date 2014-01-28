# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :library_version do
    library_id 1
    code "MyText"
    version 1
    deprecated false
  end
end
