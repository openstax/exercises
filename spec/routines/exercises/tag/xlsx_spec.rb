require 'rails_helper'
require 'content'

RSpec.describe Exercises::Tag::Spreadsheet, type: :routine do
  let(:fixture_path)  { 'spec/fixtures/sample_tags.xlsx' }

  let(:expected_tags) do
    [
      'context-cnxmod:39256206-03b0-4396-abb6-75e6ee5e3c7b',
      'context-cnxmod:102e9604-daa7-4a09-9f9e-232251d1a4ee',
      'alternate-context-cnxmod:39256206-03b0-4396-abb6-75e6ee5e3c7b',
      'lo:stax-phys:1-1-1',
      'lo:stax-phys:1-2-1',
      'lo:stax-phys:1-2-2',
      'alternate-lo:stax-phys:1-1-1',
      'filter-type:multi-cnxmod',
      'filter-type:multi-lo'
    ]
  end

  let!(:exercises) { (1..6).map { |ii| FactoryBot.create(:publication, number: ii).publishable } }

  # Disable set_slug_tags!
  before { allow_any_instance_of(Exercise).to receive(:set_slug_tags!) }

  it 'tags exercises with the sample spreadsheet' do
    expect { described_class.call(filename: fixture_path) }.to change { ExerciseTag.count }.by(20)

    exercises.each(&:reload)

    exercises.each do |exercise|
      expect(exercise.tags).not_to be_blank
      expect(exercise.tags).to satisfy do |tags|
        tags.all { |tag| expected_tags.include?(tag.name) }
      end
    end
  end

  it 'skips exercises with no changes (idempotence)' do
    expect { described_class.call(filename: fixture_path) }.to change { ExerciseTag.count }.by(20)

    expect { described_class.call(filename: fixture_path) }.not_to change { ExerciseTag.count }
  end
end
