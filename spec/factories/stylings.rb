FactoryGirl.define do
  factory :styling do
    stylable { build :stem, styles: [] }
    style Style::FREE_RESPONSE
  end
end
