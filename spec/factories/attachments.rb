FactoryBot.define do
  factory :attachment do
    asset  { 'spec/fixtures/os_exercises_logo.png' }
    parent { build :exercise }
  end
end
