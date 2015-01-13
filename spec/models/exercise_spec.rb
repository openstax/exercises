require 'rails_helper'

RSpec.describe Exercise, :type => :model do

  it { is_expected.to have_many(:questions).dependent(:destroy)
                                           .autosave(true) }
  it { is_expected.to have_many(:list_exercises).dependent(:destroy) }

  it 'can check for the presence of questions' do
    exercise = FactoryGirl.create :exercise
    exercise.send :has_questions
    expect(exercise.errors).to be_empty

    exercise.questions = []
    exercise.send :has_questions
    expect(exercise.errors[:questions]).to include("can't be blank")
  end

end
