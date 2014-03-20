FactoryGirl.define do
  factory :list do
    name { SecureRandom.hex(3) }
  end
end
