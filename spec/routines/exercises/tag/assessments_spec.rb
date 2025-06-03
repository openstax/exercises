require 'rails_helper'
require 'content'

RSpec.describe Exercises::Tag::Assessments, type: :routine do
  let(:fixture_path) { 'spec/fixtures/sample_assessments_tags.xlsx' }
  let(:book_uuid)    { SecureRandom.uuid }
  let(:page_uuid)    { 'a9ce0e38-4f52-4fe0-9433-d8df95f6e3b2' }

  let(:expected_pre_tag)    { "assessment:preparedness:https://openstax.org/orn/book:page/#{book_uuid}:#{page_uuid}" }
  let(:expected_post_tag)   { "assessment:practice:https://openstax.org/orn/book:page/#{book_uuid}:#{page_uuid}" }
  let(:expected_cnxmod_tag) { "context-cnxmod:#{page_uuid}" }

  let!(:exercises) { (1..9).map { |ii| FactoryBot.create(:publication, number: ii).publishable } }

  # Disable set_slug_tags!
  before { allow_any_instance_of(Exercise).to receive(:set_slug_tags!) }

  it 'tags exercises with the sample spreadsheet' do
    expect do
      described_class.call(filename: fixture_path, book_uuid: book_uuid)
    end.to change { ExerciseTag.count }.by(15)

    exercises.each(&:reload)

    exercises.each do |exercise|
      valid_tags = []
      valid_tags << expected_pre_tag if exercise.number <= 5
      valid_tags << [expected_post_tag, expected_cnxmod_tag] if exercise.number >= 5

      expect(exercise.tags).to satisfy do |tags|
        expect(tags.length).to eq exercise.number < 5 ? 1 : exercise.number == 5 ? 3 : 2
        tags.all { |tag| expect(valid_tags).to include tag.name }
      end
    end
  end

  it 'skips exercises with no changes (idempotence)' do
    expect do
      described_class.call(filename: fixture_path, book_uuid: book_uuid)
    end.to change { ExerciseTag.count }.by(15)

    expect { described_class.call(filename: fixture_path, book_uuid: book_uuid) }.not_to change { ExerciseTag.count }
  end
end
