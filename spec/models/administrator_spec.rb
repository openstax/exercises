require "rails_helper"

RSpec.describe Administrator, type: :model do

  subject { FactoryGirl.create(:administrator) }

  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:user) }

  it { is_expected.to validate_uniqueness_of(:user) }

end
