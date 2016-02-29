require 'rails_helper'

RSpec.describe Exercise, type: :model do

  it { is_expected.to have_many(:questions).dependent(:destroy)
                                           .autosave(true) }
  it { is_expected.to have_many(:list_exercises).dependent(:destroy) }
  it { is_expected.to have_many(:exercise_tags).dependent(:destroy) }

  it 'can check for the presence of questions' do
    exercise = FactoryGirl.create :exercise
    exercise.send :has_questions
    expect(exercise.errors).to be_empty

    exercise.questions = []
    exercise.send :has_questions
    expect(exercise.errors[:questions]).to include("can't be blank")
  end

  it 'ensures that no questions have all incorrect answers before publication' do
    exercise = FactoryGirl.create :exercise
    exercise.publication_validation
    expect(exercise.errors).to be_empty

    exercise.questions.first.stems.first.stem_answers.each do |stem_answer|
      stem_answer.update_attribute :correctness, 0.0
    end
    exercise.publication_validation
    expect(exercise.errors[:base]).to include('has a question with only incorrect answers')
  end

end
