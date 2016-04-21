require 'rails_helper'

RSpec.describe VocabTerm, type: :model do
  subject { FactoryGirl.create :vocab_term }

  it { is_expected.to have_many(:vocab_distractors) }
  it { is_expected.to have_many(:distractor_terms).through(:vocab_distractors) }

  it { is_expected.to have_many(:vocab_distracteds) }
  it { is_expected.to have_many(:distracted_terms).through(:vocab_distracteds) }

  it { is_expected.to have_many(:exercises).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:definition) }

  it { is_expected.to validate_uniqueness_of(:definition).scoped_to(:name) }
end
