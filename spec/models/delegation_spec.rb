require "rails_helper"

RSpec.describe Delegation, type: :model do

  subject(:delegation) { FactoryBot.create :delegation }

  it { is_expected.to belong_to(:delegator) }
  it { is_expected.to belong_to(:delegate) }

  it 'requires a unique delegate for each delegator' do
    delegation_2 = FactoryBot.build :delegation, delegator: delegation.delegator,
                                                 delegate: delegation.delegate
    expect(delegation_2).not_to be_valid
    expect(delegation_2.errors[:delegate_id]).to include('has already been taken')

    delegation_2.delegator = FactoryBot.build :user
    expect(delegation_2).to be_valid

    delegation_2.delegator = delegation.delegator
    expect(delegation_2).not_to be_valid

    delegation_2.delegate = FactoryBot.build :user
    expect(delegation_2).to be_valid
  end

  it 'requires delegator and delegate to be different users' do
    delegation_2 = FactoryBot.build :delegation, delegator: delegation.delegator,
                                                 delegate: delegation.delegator
    expect(delegation_2).not_to be_valid
    expect(delegation_2.errors[:delegate]).to include('must not be the same user as the Delegator')

    delegation_2.delegator = FactoryBot.build :user
    expect(delegation_2).to be_valid
  end

end
