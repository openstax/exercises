FactoryBot.define do
  factory :logic_variable_value do
    logic_variable
    seed { SecureRandom.random_number(2**31) }
    value { SecureRandom.hex }
  end
end
