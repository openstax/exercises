# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :multiple_choice_question do
    stem_id 1
    can_select_multiple false
  end
end
