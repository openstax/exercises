require "rails_helper"

RSpec.describe Derivation, type: :model do

  subject!(:derivation) { FactoryGirl.create :derivation }

  it { is_expected.to belong_to(:derived_publication) }
  it { is_expected.to belong_to(:source_publication) }

  it { is_expected.to validate_presence_of(:derived_publication) }

  it 'requires a unique source_publication for each derived_publication' do
    derivation_2 = FactoryGirl.build(:derivation,
                                     source_publication: derivation.source_publication,
                                     derived_publication: derivation.derived_publication)

    expect(derivation_2).not_to be_valid
    expect(derivation_2.errors[:source_publication]).to include 'has already been taken'

    derivation_2.source_publication = FactoryGirl.build :publication
    derivation_2.save!
  end

  it 'requires publications to be different' do
    publication = FactoryGirl.build(:publication)
    d = FactoryGirl.build(:derivation, source_publication: publication,
                                       derived_publication: publication)
    expect(d).not_to be_valid
    expect(d.errors[:base]).to include 'must have different publications'
  end

  it 'requires either a source publication or custom attribution' do
    d = FactoryGirl.build(:derivation, source_publication: nil, custom_attribution: nil)
    expect(d).not_to be_valid
    expect(d.errors[:base]).to include 'must have either a source publication or custom attribution'

    d.source_publication = FactoryGirl.build :publication
    d.save!

    d.source_publication = nil
    d.custom_attribution = 'Some cool external paper'
    d.save!
  end

end
