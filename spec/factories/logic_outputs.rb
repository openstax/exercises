# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :logic_output do
    seed 1
    values "MyText"
    logic_id 1
  end
end
