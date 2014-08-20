FactoryGirl.define do
  factory :user do
    association :openstax_accounts_user, factory: :openstax_accounts_user

    trait :admin do
      after(:create) do |user, evaluator|
        user.administrator << Administrator.create(user: user)
      end
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
