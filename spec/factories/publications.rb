FactoryGirl.define do
  factory :publication do
    embargo_children_only false
    major_change false

    transient do
      number nil
    end

    trait :published do
      published_at { Time.now }
    end

    after(:build) do |publication, evaluator|
      publication.publishable ||= build :exercise, publication: publication
      class_name = publication.publishable.class.name
      publication_group_attributes = { publishable_type: class_name, number: evaluator.number }
      publication.publication_group = PublicationGroup.find_by(publication_group_attributes) ||
                                      build(:publication_group, publication_group_attributes) \
        if evaluator.number.present?
      publication.license ||= ClassLicense.find_or_create_by(class_name: class_name).license
    end
  end
end
