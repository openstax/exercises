FactoryGirl.define do
  factory :trusted_application do
    association :application, factory: :doorkeeper_application
  end
end
