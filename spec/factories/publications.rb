FactoryGirl.define do
  factory :publication do
    published_at nil
    yanked_at nil
    embargoed_until nil
    embargo_children_only false
    major_change false

    trait :published do
      published_at { Time.now }
    end

    after(:build) do |publication|
      publication.publishable ||= build :exercise, publication: publication
      class_name = publication.publishable.class.name
      publication.license ||= (
        ClassLicense.find_by(class_name: class_name) || \
        create(:class_license, class_name: class_name)
      ).license
      publication.number ||= (Publication.where(
        publishable_type: publication.publishable_type
      ).maximum(:number) || 0) + 1
      publication.version ||= (Publication.where(
        publishable_type: publication.publishable_type
      ).maximum(:version) || 0) + 1
    end
  end
end
