require 'rails_helper'

RSpec.describe Exercises::Untag::Xlsx, type: :routine do
  before(:all) do
    DatabaseCleaner.start

    @exercises = (1..6).map { |ii| FactoryBot.create(:publication, number: ii).publishable }

    @fixture_path = 'spec/fixtures/sample_tags.xlsx'

    # Add the tags but don't publish the exercises
    Exercises::Tag::Xlsx.call(filename: @fixture_path)
    @exercises.each { |exercise| exercise.reload.publication.update_attribute :published_at, nil }
  end
  after(:all) { DatabaseCleaner.clean }

  it 'removes exercise tags based on the sample spreadsheet' do
    expect { described_class.call(filename: @fixture_path) }.to change{ ExerciseTag.count }.by(-20)

    @exercises.each { |exercise| expect(exercise.reload.tags).to be_empty }
  end

  it 'skips exercises with no changes' do
    expect { described_class.call(filename: @fixture_path) }.to change{ ExerciseTag.count }.by(-20)

    expect { described_class.call(filename: @fixture_path) }.not_to change{ ExerciseTag.count }
  end
end
