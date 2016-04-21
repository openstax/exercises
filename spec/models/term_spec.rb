require 'rails_helper'

RSpec.describe Term, type: :model do
  subject { FactoryGirl.create :term }

  it { is_expected.to have_many(:distractors) }
  it { is_expected.to have_many(:distractor_terms).through(:distractors) }

  it { is_expected.to have_many(:distracteds) }
  it { is_expected.to have_many(:distracted_terms).through(:distracteds) }

  it { is_expected.to have_many(:exercises).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:description) }

  it { is_expected.to validate_uniqueness_of(:description).scoped_to(:name) }
end
