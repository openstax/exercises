FactoryBot.define do
  factory :doorkeeper_application, class: Doorkeeper::Application do
    association :owner, factory: :openstax_accounts_group

    sequence(:name) { |n| "Application #{n}" }
    redirect_uri    { "https://app.com/callback" }
  end
end
