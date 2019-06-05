require 'rails_helper'

RSpec.describe VocabDistractor, type: :model do
  subject(:vocab_distractor) { FactoryBot.create :vocab_distractor }

  it { is_expected.to belong_to(:vocab_term) }

  it { is_expected.to belong_to(:distractor_publication_group) }
  it { is_expected.to validate_presence_of(:distractor_term) }

  it do
    is_expected.to validate_uniqueness_of(:distractor_publication_group).scoped_to(:vocab_term_id)
  end

  it 'finds the latest distractor terms' do
    distractor_term = FactoryBot.create :vocab_term

    vocab_distractor.update_attribute :distractor_publication_group,
                                      distractor_term.publication.publication_group
    expect(vocab_distractor.distractor_term).to eq distractor_term

    distractor_term.publication.publish.save!
    distractor_term_2 = distractor_term.new_version

    expect(vocab_distractor.reload.distractor_term).to eq distractor_term

    distractor_term_2.publication.publish.save!
    expect(vocab_distractor.reload.distractor_term).to eq distractor_term_2

    distractor_term_3 = FactoryBot.create :vocab_term
    vocab_distractor.distractor_term = distractor_term_3
    expect(vocab_distractor.distractor_term).to eq distractor_term_3
    expect(vocab_distractor.distractor_publication_group).to(
      eq distractor_term_3.publication.publication_group
    )

    vocab_distractor.save!
    expect(vocab_distractor.distractor_publication_group).to(
      eq distractor_term_3.publication.publication_group
    )
    expect(vocab_distractor.distractor_term).to eq distractor_term_3
  end
end
