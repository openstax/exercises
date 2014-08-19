# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :exercise_license, :class => 'ExerciseLicenses' do
    exercise nil
    license nil
    request_attribution false
    start_at "2014-08-18 16:30:09"
  end
end
