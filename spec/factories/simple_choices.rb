# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :simple_choice do
    content_id 1
    position 1
    credit 1.5
    multiple_choice_question_id 1
  end
end
