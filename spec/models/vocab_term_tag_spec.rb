require 'rails_helper'

RSpec.describe VocabTermTag, type: :model do
  subject(:vocab_term_tag) { FactoryBot.create :vocab_term_tag }

  it { is_expected.to belong_to(:vocab_term) }
  it { is_expected.to belong_to(:tag) }

  it { is_expected.to validate_uniqueness_of(:tag).scoped_to(:vocab_term_id) }
end
