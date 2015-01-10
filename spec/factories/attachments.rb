FactoryGirl.define do
  factory :attachment do
    parent { build :exercise }
    asset { SecureRandom.hex(32) }
  end
end
