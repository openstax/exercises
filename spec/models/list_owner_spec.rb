require "rails_helper"

RSpec.describe ListOwner, type: :model do

  it { is_expected.to belong_to(:list) }
  it { is_expected.to belong_to(:owner) }

  it { is_expected.to validate_presence_of(:list) }
  it { is_expected.to validate_presence_of(:owner) }

  it 'requires a unique owner for each list' do
    list_owner_1 = FactoryGirl.create :list_owner
    list_owner_2 = FactoryGirl.build :list_owner,
                                     list: list_owner_1.list,
                                     owner: list_owner_1.owner
    expect(list_owner_2).not_to be_valid
    expect(list_owner_2.errors[:list]).to(
      include('has already been taken'))

    list_owner_2.list = FactoryGirl.build :list
    expect(list_owner_2).to be_valid

    list_owner_2.list = list_owner_1.list
    expect(list_owner_2).not_to be_valid

    list_owner_2.owner = FactoryGirl.build :user
    expect(list_owner_2).to be_valid
  end

end
