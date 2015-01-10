require "rails_helper"

RSpec.describe LicenseCompatibility, :type => :model do

  subject { FactoryGirl.create(:license) }

  it { is_expected.to belong_to(:original_license) }
  it { is_expected.to belong_to(:combined_license) }

  it { is_expected.to validate_presence_of(:original_license) }
  it { is_expected.to validate_presence_of(:combined_license) }

  it { is_expected.to validate_uniqueness_of(:combined_license)
                        .scoped_to(:original_license_id) }

end
