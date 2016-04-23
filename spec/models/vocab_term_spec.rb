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

  it 'ensures that it has at least 1 distractor before publication' do
    vocab_term = FactoryGirl.create :vocab_term
    vocab_term.publication_validation
    expect(vocab_term.errors).to be_empty

    vocab_term.vocab_distractors.destroy_all
    vocab_term.distractor_literals = ['Distractor']
    vocab_term.publication_validation
    expect(vocab_term.errors).to be_empty

    vocab_term.distractor_literals = []
    vocab_term.publication_validation
    expect(vocab_term.errors[:base]).to include('must have at least 1 distractor')
  end
end
