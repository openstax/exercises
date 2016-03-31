require 'rails_helper'

module Exercises::Tag
  RSpec.describe Xlsx do
    let(:fixture_path)  { 'spec/fixtures/sample_tags.xlsx' }

    let(:expected_tags) { Set.new [
      'cnxmod:39256206-03b0-4396-abb6-75e6ee5e3c7b',
      'cnxmod:102e9604-daa7-4a09-9f9e-232251d1a4ee',
      'alternate-cnxmod:39256206-03b0-4396-abb6-75e6ee5e3c7b',
      'lo:stax-phys:1-1-1',
      'lo:stax-phys:1-2-1',
      'lo:stax-phys:1-2-2',
      'alternate-lo:stax-phys:1-1-1',
      'filter-type:multi-cnxmod'
    ] }

    let!(:exercises) do
      (1..6).map{ |i| FactoryGirl.create(:publication, number: -i).publishable }
    end

    it 'tags exercises with the sample spreadsheet' do
      expect { described_class.call(filename: fixture_path) }.to change{ ExerciseTag.count }.by(17)

      exercises.each(&:reload)

      exercises.each do |exercise|
        expect(exercise.tags).not_to be_blank
        expect(exercise.tags).to satisfy do |tags|
          tags.all{ |tag| expected_tags.include?(tag.name) }
        end
      end
    end

    it 'skips exercises with no changes' do
      expect { described_class.call(filename: fixture_path) }.to change{ ExerciseTag.count }.by(17)

      expect { described_class.call(filename: fixture_path) }.not_to change{ ExerciseTag.count }
    end
  end
end
