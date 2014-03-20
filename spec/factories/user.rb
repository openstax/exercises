FactoryGirl.define do
  factory :user do
    association :openstax_connect_user, factory: :openstax_connect_user
    association :default_list, factory: :list

    trait :admin do
      is_admin true
    end

    trait :terms_agreed do
      after(:create) do |user, evaluator|
        FinePrint::Contract.all.each do |contract|
          FinePrint.sign_contract(user, contract)
        end
      end
    end
  end
end
