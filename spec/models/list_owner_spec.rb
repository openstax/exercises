require "rails_helper"

RSpec.describe ListOwner, :type => :model do

  subject { FactoryGirl.create(:list_owner) }

  it { is_expected.to belong_to(:list) }
  it { is_expected.to belong_to(:owner) }

  it { is_expected.to validate_presence_of(:list) }
  it { is_expected.to validate_presence_of(:owner) }

  it { is_expected.to validate_uniqueness_of(:owner).scoped_to(:list_id) }

end
