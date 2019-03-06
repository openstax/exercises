FactoryBot.define do
  factory :license do
    name { Faker::Lorem.words.join('_') }
    title { Faker::Lorem.words.join(' ').capitalize }
    url { Faker::Internet.url }
    publishing_contract { Faker::Lorem.paragraphs }
    copyright_notice { Faker::Lorem.sentence }

    transient do
      licensed_classes { ['Exercise', 'CommunitySolution', 'List'] }
    end

    after(:build) do |license, evaluator|
      evaluator.licensed_classes.each do |class_name|
        license.class_licenses << build(:class_license,
                                        license: license,
                                        class_name: class_name)
      end
    end
  end
end
