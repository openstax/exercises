require 'rails_helper'

RSpec.describe ExerciseTag, type: :model do
  subject(:exercise_tag) { FactoryBot.create :exercise_tag }

  it { is_expected.to belong_to(:exercise) }
  it { is_expected.to belong_to(:tag) }

  it { is_expected.to validate_uniqueness_of(:tag).scoped_to(:exercise_id) }
end
