require 'rails_helper'

RSpec.describe DelegationAccessPolicy, type: :access_policy do
  let(:anon) { AnonymousUser.instance }
  let(:user) { FactoryBot.create(:user) }
  let(:app)  { FactoryBot.create(:doorkeeper_application) }
  let(:dg)   { FactoryBot.create(:delegation) }

  context 'create, destroy' do
    it 'cannot be accessed by anonymous, apps, other users or delegates' do
      expect(described_class.action_allowed?(:create, anon, dg)).to eq false
      expect(described_class.action_allowed?(:destroy, anon, dg)).to eq false

      expect(described_class.action_allowed?(:create, app, dg)).to eq false
      expect(described_class.action_allowed?(:destroy, app, dg)).to eq false

      expect(described_class.action_allowed?(:create, user, dg)).to eq false
      expect(described_class.action_allowed?(:destroy, user, dg)).to eq false

      expect(described_class.action_allowed?(:create, dg.delegate, dg)).to eq false
      expect(described_class.action_allowed?(:destroy, dg.delegate, dg)).to eq false
    end

    it 'can be accessed by the delegator' do
      expect(described_class.action_allowed?(:create, dg.delegator, dg)).to eq true
      expect(described_class.action_allowed?(:destroy, dg.delegator, dg)).to eq true
    end
  end

  context 'other actions' do
    it 'cannot be accessed' do
      expect(described_class.action_allowed?(:other, anon, dg)).to eq false
      expect(described_class.action_allowed?(:other, app, dg)).to eq false
      expect(described_class.action_allowed?(:other, user, dg)).to eq false
      expect(described_class.action_allowed?(:other, dg.delegate, dg)).to eq false
      expect(described_class.action_allowed?(:other, dg.delegator, dg)).to eq false
    end
  end
end
