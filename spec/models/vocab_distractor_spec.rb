require 'rails_helper'

RSpec.describe VocabDistractor, type: :model do
  subject { FactoryGirl.create :vocab_distractor }

  it { is_expected.to belong_to(:vocab_term) }
  it { is_expected.to belong_to(:distractor_term) }

  it { is_expected.to validate_presence_of(:vocab_term) }
  it { is_expected.to validate_presence_of(:distractor_term) }

  it { is_expected.to validate_uniqueness_of(:distractor_term).scoped_to(:vocab_term_id) }
end