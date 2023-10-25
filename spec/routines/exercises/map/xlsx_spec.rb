require 'rails_helper'

RSpec.describe Exercises::Map::Spreadsheet, type: :routine do
  let(:fixture_path)  { 'spec/fixtures/sample_map.xlsx' }

  let(:source_tags)   do
    [
      'context-cnxmod:1f8a0ca4-24a2-44fd-9706-f43ac0a5904e',
      'context-cnxmod:b13912c1-d7fb-4f5f-9b8a-04a0ee9ed00f',
      'context-cnxmod:c90e0c3f-d259-40ae-845f-6cb0a364e388',
      'context-cnxmod:1a3eb179-6a06-4a14-81bb-90fce075c39d'
    ]
  end
  let(:destination_tags) do
    [
      'context-cnxmod:417f4cba-e262-46f7-b4ae-344b2d2777c7',
      'context-cnxmod:3ed13320-bd28-4d2e-bd34-5fe5bcae8727',
      'context-cnxmod:29bd033a-4ebd-4d86-9634-024362306fb7',
      'context-cnxmod:91c0e0e4-d1f8-4443-b1d2-69711fb9b459'
    ]
  end

  let!(:exercises) do
    (1..4).map do |ii|
      FactoryBot.create(:publication, number: ii).publishable.tap do |exercise|
        exercise.tags << source_tags[ii - 1]
      end
    end
  end

  it 'map exercise cnxmod tags with the sample spreadsheet' do
    expect { described_class.call(filename: fixture_path) }.to change{ ExerciseTag.count }.by(4)

    exercises.each(&:reload)

    exercises.each_with_index do |exercise, ii|
      tags = exercise.tags.map(&:name)
      expect(tags).to include(source_tags[ii])
      expect(tags).to include(destination_tags[ii])
    end
  end

  it 'skips exercises with no changes (idempotence)' do
    expect { described_class.call(filename: fixture_path) }.to change { ExerciseTag.count }.by(4)

    expect { described_class.call(filename: fixture_path) }.not_to change { ExerciseTag.count }
  end
end
