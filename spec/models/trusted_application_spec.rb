require 'rails_helper'

RSpec.describe TrustedApplication, type: :model do

  subject(:trusted_application) { FactoryBot.create(:trusted_application) }

  it { is_expected.to belong_to(:application) }

  it { is_expected.to validate_presence_of(:application) }

  it { is_expected.to validate_uniqueness_of(:application) }

end
