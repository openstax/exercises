require 'rails_helper'

RSpec.describe VocabDistractor, type: :model do
  subject(:vocab_distractor) { FactoryGirl.create :vocab_distractor }

  it { is_expected.to belong_to(:vocab_term) }

  it { is_expected.to validate_presence_of(:vocab_term) }
  it { is_expected.to validate_presence_of(:distractor_term) }

  it { is_expected.to validate_uniqueness_of(:distractor_term_number).scoped_to(:vocab_term_id) }

  it 'finds the latest distractor terms' do
    distractor_term = FactoryGirl.create :vocab_term

    vocab_distractor.update_attribute :distractor_term_number, distractor_term.number
    expect(vocab_distractor.distractor_term).to eq distractor_term

    distractor_term.publication.publish.save!
    distractor_term_2 = distractor_term.new_version

    expect(vocab_distractor.reload.distractor_term).to eq distractor_term

    distractor_term_2.publication.publish.save!
    expect(vocab_distractor.reload.distractor_term).to eq distractor_term_2

    distractor_term_3 = FactoryGirl.create :vocab_term
    vocab_distractor.distractor_term = distractor_term_3
    expect(vocab_distractor.distractor_term).to eq distractor_term_3
    expect(vocab_distractor.distractor_term_number).to eq distractor_term_3.number

    vocab_distractor.save!
    expect(vocab_distractor.distractor_term_number).to eq distractor_term_3.number
    expect(vocab_distractor.distractor_term).to eq distractor_term_3
  end
end
