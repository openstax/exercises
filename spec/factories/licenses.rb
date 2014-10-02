FactoryGirl.define do
  factory :license do
    name { Faker::Lorem.words.join('_') }
    title { Faker::Lorem.words.join(' ').capitalize }
    url { Faker::Internet.url }
    publishing_contract { Faker::Lorem.paragraphs }
    copyright_notice { Faker::Lorem.sentence }

    ignore do
      skip_class_licenses false
    end

    after(:build) do |license, evaluator|
      next if evaluator.skip_class_licenses
      ['Exercise', 'Solution', 'Library', 'List'].each do |class_name|
        license.class_licenses << FactoryGirl.build(:class_license,
                                                    license: license,
                                                    class_name: class_name)
      end
    end
  end
end
