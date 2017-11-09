FactoryBot.define do
  factory :class_license do
    license
    class_name { Faker::Lorem.word.capitalize }
  end
end
