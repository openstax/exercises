require "rails_helper"

RSpec.describe ListVocabTerm, type: :model do

  subject { FactoryGirl.create :list_vocab_term }

  it { is_expected.to belong_to(:list) }
  it { is_expected.to belong_to(:vocab_term) }

  it { is_expected.to validate_presence_of(:list) }
  it { is_expected.to validate_presence_of(:vocab_term) }

  it { is_expected.to validate_uniqueness_of(:vocab_term).scoped_to(:list_id) }

end
