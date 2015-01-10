require "rails_helper"

RSpec.describe Logic, :type => :model do

  subject { FactoryGirl.create(:logic) }

  it { is_expected.to belong_to(:parent) }

  it { is_expected.to have_many(:logic_libraries) }
  it { is_expected.to have_many(:logic_variables) }

  it { is_expected.to validate_presence_of(:parent) }
  it { is_expected.to validate_presence_of(:language) }

  it { is_expected.to validate_uniqueness_of(:parent) }

  it { is_expected.to validate_inclusion_of(:language).in_array(Language.all) }

end
