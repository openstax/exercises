require "rails_helper"

RSpec.describe Administrator, type: :model do

  subject(:administrator) { FactoryBot.create :administrator }

  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_uniqueness_of(:user) }

end
