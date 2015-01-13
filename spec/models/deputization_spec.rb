require "rails_helper"

RSpec.describe Deputization, :type => :model do

  it { is_expected.to belong_to(:deputy) }
  it { is_expected.to belong_to(:deputizer) }

  it { is_expected.to validate_presence_of(:deputy) }
  it { is_expected.to validate_presence_of(:deputizer) }

  it 'requires a unique deputizer for each deputy' do
    deputization_1 = FactoryGirl.create :deputization
    deputization_2 = FactoryGirl.build :deputization,
                                       deputizer: deputization_1.deputizer,
                                       deputy: deputization_1.deputy
    expect(deputization_2).not_to be_valid
    expect(deputization_2.errors[:deputizer]).to(
      include('has already been taken'))

    deputization_2.deputizer = FactoryGirl.build :user
    expect(deputization_2).to be_valid

    deputization_2.deputizer = deputization_1.deputizer
    expect(deputization_2).not_to be_valid

    deputization_2.deputy = FactoryGirl.build :user
    expect(deputization_2).to be_valid
  end

end
