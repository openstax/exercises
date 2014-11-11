require "rails_helper"

RSpec.describe License, :type => :model do

  it { is_expected.to have_many(:publications).dependent(:destroy) }
  it { is_expected.to have_many(:class_licenses).dependent(:destroy) }

  it { is_expected.to have_many(:combined_license_compatibilities)
                        .dependent(:destroy) }
  it { is_expected.to have_many(:original_license_compatibilities)
                        .dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:url) }
  it { is_expected.to validate_presence_of(:publishing_contract) }
  it { is_expected.to validate_presence_of(:copyright_notice) }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_uniqueness_of(:title) }
  it { is_expected.to validate_uniqueness_of(:url) }

  it 'should return select options for publishable objects' do
  end

end
