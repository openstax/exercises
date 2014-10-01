FactoryGirl.define do
  factory :doorkeeper_application, :class => Doorkeeper::Application do
    sequence(:name){ |n| "Application #{n}" }
    redirect_uri "https://app.com/callback"
    association :owner, factory: :openstax_accounts_group

    trait :trusted do
      trusted true
    end
  end
end
