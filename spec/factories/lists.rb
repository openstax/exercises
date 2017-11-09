FactoryBot.define do
  factory :list do
    name { Faker::Lorem.words.join(' ').capitalize }

    transient { list_publication_groups_count { list_publication_groups.empty? ? 5 : 0 } }

    after(:build) do |list, evaluator|
      evaluator.list_publication_groups_count.times do
        list.list_publication_groups << build(:list_publication_group, list: list)
      end
    end
  end
end
