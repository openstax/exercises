FactoryBot.define do
  factory :license_compatibility do
    association :original_license, factory: :license
    association :combined_license, factory: :license
  end
end
