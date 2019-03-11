require 'rails_helper'

RSpec.describe HasTags, type: :model do
  context 'modifies exercises' do
    subject(:exercise) { FactoryBot.create :exercise }

    it { is_expected.to have_many(:exercise_tags) }

    it 'receives tag-related methods' do
      expect(Tag.all).to be_empty
      expect(exercise.tags).to be_empty
      expect(ExerciseTag.count).to eq 0

      exercise.tags << 'abc'

      expect(Tag.first.name).to eq 'abc'
      expect(exercise.tags.map(&:name)).to eq ['abc']
      expect(ExerciseTag.count).to eq 1

      exercise.tags << 'def'

      expect(Tag.second.name).to eq 'def'
      expect(exercise.tags.map(&:name)).to eq ['abc', 'def']
      expect(ExerciseTag.count).to eq 2

      exercise.tags += ['ghi']

      expect(Tag.third.name).to eq 'ghi'
      expect(exercise.tags.map(&:name)).to eq ['abc', 'def', 'ghi']
      expect(ExerciseTag.count).to eq 3

      exercise.tags = ['a', 'b', 'c']
      exercise.save!

      expect(Tag.all[3].name).to eq 'a'
      expect(Tag.all[4].name).to eq 'b'
      expect(Tag.all[5].name).to eq 'c'
      expect(exercise.tags.map(&:name)).to eq ['a', 'b', 'c']
      expect(ExerciseTag.count).to eq 3
    end
  end
end
