FactoryBot.define do
  factory :delegation do
    association :delegator, factory: :user
    association :delegate,  factory: :user

    can_create  { [true, false].sample }
    can_update  { [true, false].sample }
    can_destroy { [true, false].sample }
  end
end
