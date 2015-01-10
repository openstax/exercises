require "rails_helper"

RSpec.describe Derivation, :type => :model do

  subject { FactoryGirl.create(:derivation) }

  it { is_expected.to belong_to(:derived_publication) }
  it { is_expected.to belong_to(:source_publication) }

  it { is_expected.to validate_presence_of(:derived_publication) }
  it { is_expected.to validate_presence_of(:source_publication) }

  it { is_expected.to validate_uniqueness_of(:source_publication)
                        .scoped_to(:derived_publication_id) }

  it 'should require publications to be different' do
    publication = FactoryGirl.build(:publication)
    d = FactoryGirl.build(:derivation,
                          source_publication: publication,
                          derived_publication: publication)
    expect(d).not_to be_valid
    expect(d.errors[:base]).to include(
      'must have different publications')
  end

  it 'should require either a source publication or custom attribution' do
    d = FactoryGirl.build(:derivation,
                          source_publication: nil, custom_attribution: nil)
    expect(d).not_to be_valid
    expect(d.errors[:base]).to include(
      'must have either a source publication or custom attribution')
  end

end
