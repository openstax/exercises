require 'rails_helper'

RSpec.describe Exercise, :type => :model do
  context 'class' do
    it { is_expected.to have_many(:parts).dependent(:destroy) }
    it { is_expected.to have_many(:questions) }
    it { is_expected.to have_many(:items) }
    it { is_expected.to have_many(:answers) }
    it { is_expected.to have_many(:combo_choices) }
    it { is_expected.to have_many(:list_exercises).dependent(:destroy) }
    it { is_expected.to have_many(:lists) }
  end

  context 'instance' do
    let!(:exercise) { FactoryGirl.create :exercise }

    it 'requires parts for publication' do
      exercise.send :has_parts
      expect(exercise.errors).to be_empty

      exercise.parts = []
      exercise.send :has_parts
      expect(exercise.errors[:parts]).to include("can't be blank")
    end

    it 'requires content for publication' do
      exercise.send :has_content
      expect(exercise.errors).to be_empty

      exercise.parts = []
      exercise.send :has_content
      expect(exercise.errors).to be_empty

      exercise.background = ''
      exercise.send :has_content
      expect(exercise.errors[:content]).to include("can't be blank")
    end
  end
end
