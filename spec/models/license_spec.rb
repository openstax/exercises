require "rails_helper"

RSpec.describe License, type: :model do

  subject(:license) { FactoryBot.create(:license) }

  it { is_expected.to have_many(:publications) }
  it { is_expected.to have_many(:class_licenses).dependent(:destroy) }

  it { is_expected.to have_many(:combined_license_compatibilities).dependent(:destroy) }
  it { is_expected.to have_many(:original_license_compatibilities).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:url) }
  it { is_expected.to validate_presence_of(:publishing_contract) }
  it { is_expected.to validate_presence_of(:copyright_notice) }

  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_uniqueness_of(:title) }
  it { is_expected.to validate_uniqueness_of(:url) }

  it 'should know if it is valid for a given publishable object' do
    license = FactoryBot.create :license, licensed_classes: ['CommunitySolution', 'List']
    expect(license.valid_for?(Exercise.name)).to eq false

    class_license = FactoryBot.create :class_license, license: license, class_name: 'Exercise'
    expect(license.reload.valid_for?(Exercise.name)).to eq true
  end

end
