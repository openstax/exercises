FactoryBot.define do
  factory :derivation do
    association :source_publication, factory: :publication
    association :derived_publication, factory: :publication
    custom_attribution { nil }
  end
end
