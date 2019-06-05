require "rails_helper"

RSpec.describe ClassLicense, type: :model do

  subject(:class_license) { FactoryBot.create :class_license }

  it { is_expected.to belong_to(:license) }

  it { is_expected.to validate_presence_of(:class_name) }

  it { is_expected.to validate_uniqueness_of(:class_name).scoped_to(:license_id) }

end
