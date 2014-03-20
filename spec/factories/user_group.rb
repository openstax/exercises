FactoryGirl.define do
  factory :user_group do
    name { SecureRandom.hex(3) }
  end
end
