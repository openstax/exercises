FactoryBot.define do
  factory :styling do
    stylable { build :stem, styles: [] }
    style { Style::FREE_RESPONSE }

    after(:build) { |styling, evaluator| evaluator.stylable.stylings << styling }
  end
end
