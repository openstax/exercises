FactoryBot.define do
  factory :deputization do
    association :deputizer, factory: :user
    association :deputy, factory: :openstax_accounts_group

    after(:build) do |deputization|
      deputization.deputy.add_member(build :user)
    end
  end
end
