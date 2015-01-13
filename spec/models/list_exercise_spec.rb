require "rails_helper"

RSpec.describe ListExercise, :type => :model do

  subject { FactoryGirl.create :list_exercise }

  it { is_expected.to belong_to(:list) }
  it { is_expected.to belong_to(:exercise) }

  it { is_expected.to validate_presence_of(:list) }
  it { is_expected.to validate_presence_of(:exercise) }

  it 'requires a unique exercise for each list' do
    list_exercise_1 = FactoryGirl.create :list_exercise
    list_exercise_2 = FactoryGirl.build :list_exercise,
                                        list: list_exercise_1.list,
                                        exercise: list_exercise_1.exercise
    expect(list_exercise_2).not_to be_valid
    expect(list_exercise_2.errors[:exercise]).to(
      include('has already been taken'))

    list_exercise_2.list.reload
    list_exercise_2.exercise = FactoryGirl.build :exercise
    expect(list_exercise_2).to be_valid

    list_exercise_2.exercise = list_exercise_1.exercise
    expect(list_exercise_2).not_to be_valid

    list_exercise_2.list = FactoryGirl.build :list
    expect(list_exercise_2).to be_valid
  end

end
