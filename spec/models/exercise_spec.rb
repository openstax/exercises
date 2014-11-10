require 'rails_helper'

RSpec.describe Exercise, :type => :model do

  it { is_expected.to have_many(:questions).dependent(:destroy)
                                           .autosave(true) }
  it { is_expected.to have_many(:list_exercises).dependent(:destroy) }

  context 'instance' do
    let!(:exercise) { FactoryGirl.create :exercise }

    it 'can check for the presence of questions' do
      exercise.send :has_questions
      expect(exercise.errors).to be_empty

      exercise.parts = []
      exercise.send :has_questions
      expect(exercise.errors[:questions]).to include("can't be blank")
    end

    it 'can check for the presence of content' do
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
