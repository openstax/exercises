require 'rails_helper'

RSpec.describe Tag, type: :model do
  subject { FactoryGirl.create :tag }

  it { is_expected.to have_many(:exercise_tags).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
end
