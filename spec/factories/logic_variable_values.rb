FactoryGirl.define do
  factory :logic_variable_value do
    logic_variable
    seed { SecureRandom.hex }
    value { SecureRandom.hex }
  end
end
