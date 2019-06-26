FactoryBot.define do
  factory :attachment do
    asset  { File.open('spec/fixtures/os_exercises_logo.png') }
    parent { build :exercise }
  end
end
