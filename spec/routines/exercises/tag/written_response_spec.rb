require 'rails_helper'

RSpec.describe Exercises::Tag::WrittenResponse, type: :routine do
  let(:fixture_path) { 'spec/fixtures/sample_tag_wrqs.xlsx' }
  let(:book_uuid)    { SecureRandom.uuid }
  let(:page_uuid1)   { '65f20d1a-5bf0-4cd1-8d99-62851f9bc5ae' }
  let(:page_uuid2)   { 'cb8a3493-8c10-4deb-842d-fd8134796890' }

  let(:pre_tag)  { "assessment:preparedness:https://openstax.org/orn/book:page/#{book_uuid}:#{page_uuid1}" }
  let(:post_tag) { "assessment:practice:https://openstax.org/orn/book:page/#{book_uuid}:#{page_uuid1}" }

  # Fixture rows: 35604/page_uuid1/Small, 35605/page_uuid1/Small, 35606/page_uuid1/Medium,
  #               35609/page_uuid2/Small, 35610/page_uuid2/Small
  # Pre-seed with assessment tags that should be removed by the routine.
  let!(:exercises) do
    [35604, 35605, 35606, 35609, 35610].map do |number|
      exercise = FactoryBot.create(:publication, number: number).publishable
      exercise.tags << pre_tag
      exercise.tags << post_tag
      exercise.save!
      exercise
    end
  end

  # Disable set_slug_tags!
  before { allow_any_instance_of(Exercise).to receive(:set_slug_tags!) }

  it 'removes preparedness/practice tags and adds written-response tags' do
    orn1            = "https://openstax.org/orn/book:page/#{book_uuid}:#{page_uuid1}"
    orn2            = "https://openstax.org/orn/book:page/#{book_uuid}:#{page_uuid2}"
    expected_small  = 'response-size:small'
    expected_medium = 'response-size:medium'

    # 5 exercises × 2 assessment tags removed, 2 new tags added = net 0
    expect do
      described_class.call(filename: fixture_path, book_uuid: book_uuid)
    end.not_to change { ExerciseTag.count }

    exercises.each(&:reload)
    tag_names = exercises.flat_map { |ex| ex.tags.map(&:name) }

    expect(tag_names).not_to include(pre_tag)
    expect(tag_names).not_to include(post_tag)

    # 35604, 35605 — page_uuid1, Small
    exercises.first(2).each do |exercise|
      expect(exercise.tags.map(&:name)).to include("written-response:practice:#{orn1}", expected_small)
    end

    # 35606 — page_uuid1, Medium
    expect(exercises[2].tags.map(&:name)).to include("written-response:practice:#{orn1}", expected_medium)

    # 35609, 35610 — page_uuid2, Small
    exercises.last(2).each do |exercise|
      expect(exercise.tags.map(&:name)).to include("written-response:practice:#{orn2}", expected_small)
    end
  end

  it 'is idempotent (skips exercises with no changes on second call)' do
    described_class.call(filename: fixture_path, book_uuid: book_uuid)

    expect do
      described_class.call(filename: fixture_path, book_uuid: book_uuid)
    end.not_to change { ExerciseTag.count }
  end
end
