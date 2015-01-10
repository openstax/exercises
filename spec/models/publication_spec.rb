require "rails_helper"

RSpec.describe Publication, :type => :model do

  subject { FactoryGirl.create(:publication) }

  it { is_expected.to belong_to(:publishable) }
  it { is_expected.to belong_to(:license) }

  it { is_expected.to have_many(:authors).dependent(:destroy) }
  it { is_expected.to have_many(:copyright_holders).dependent(:destroy) }
  it { is_expected.to have_many(:editors).dependent(:destroy) }

  it { is_expected.to have_many(:sources).dependent(:destroy) }
  it { is_expected.to have_many(:derivations).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:publishable) }

  it { is_expected.to validate_presence_of(:number) }
  it { is_expected.to validate_presence_of(:version) }

  xit 'requires a unique publishable' do
  end

  xit 'requires a unique version for each number and publishable_type' do
  end

  xit 'requires a valid license' do
  end

  xit 'automatically assigns number and version on creation' do
  end

  xit 'defaults to ordering by number and version' do
  end

  xit 'generates a uid based on the number and version' do
  end

  xit 'knows if it is published or not' do
  end

end
