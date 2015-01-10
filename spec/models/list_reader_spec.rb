require "rails_helper"

RSpec.describe ListReader, :type => :model do

  subject { FactoryGirl.create(:list_reader) }

  it { is_expected.to belong_to(:list) }
  it { is_expected.to belong_to(:reader) }

  it { is_expected.to validate_presence_of(:list) }
  it { is_expected.to validate_presence_of(:reader) }

  it { is_expected.to validate_uniqueness_of(:reader).scoped_to(:list_id) }

end
