FactoryBot.define do
  factory :delegation do
    association :delegator, factory: :user
    association :delegate,  factory: :user

    can_assign_authorship { [true, false].sample }
    can_assign_copyright  { [true, false].sample }
    can_read              { [true, false].sample }
    can_update            { [true, false].sample }
  end
end
