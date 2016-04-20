FactoryGirl.define do
  factory :term do
    name                { Faker::Lorem.words.join(' ').capitalize }
    description         { Faker::Lorem.paragraph }
    distractor_literals { [] }

    transient { distractors_count { distractors.empty? ? 2 : 0 } }

    after(:build) do |term, evaluator|
      term.publication ||= build(:publication, publishable: term)

      evaluator.distractors_count.times { term.distractors << build(:distractor,
                                                                    parent_term: term) }
    end

    trait(:published) { after(:build) { |term| term.publication.publish } }
  end
end
