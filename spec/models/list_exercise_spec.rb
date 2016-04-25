require "rails_helper"

RSpec.describe ListExercise, type: :model do

  subject { FactoryGirl.create :list_exercise }

  it { is_expected.to belong_to(:list) }
  it { is_expected.to belong_to(:exercise) }

  it { is_expected.to validate_presence_of(:list) }
  it { is_expected.to validate_presence_of(:exercise) }

  it { is_expected.to validate_uniqueness_of(:exercise).scoped_to(:list_id) }

end
