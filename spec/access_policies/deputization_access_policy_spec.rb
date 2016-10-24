require 'rails_helper'

RSpec.describe DeputizationAccessPolicy, type: :access_policy do
  let(:anon) { AnonymousUser.instance }
  let(:user) { FactoryGirl.create(:user) }
  let(:app)  { FactoryGirl.create(:doorkeeper_application) }
  let(:dp)   { FactoryGirl.create(:deputization) }

  context 'create, destroy' do
    it 'cannot be accessed by anonymous, unauthorized users or apps' do
      expect(OSU::AccessPolicy.action_allowed?(:create, anon, dp)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:destroy, anon, dp)).to eq false

      expect(OSU::AccessPolicy.action_allowed?(:create, user, dp)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:destroy, user, dp)).to eq false

      expect(OSU::AccessPolicy.action_allowed?(:create, app, dp)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:destroy, app, dp)).to eq false
    end

    it 'can be accessed by the deputizer' do
      expect(OSU::AccessPolicy.action_allowed?(:create, dp.deputizer, dp)).to eq true

      expect(OSU::AccessPolicy.action_allowed?(:destroy, dp.deputizer, dp)).to eq true
    end
  end

  context 'other actions' do
    it 'cannot be accessed' do
      expect(OSU::AccessPolicy.action_allowed?(:other, anon, dp)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, user, dp)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, app, dp)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, dp.deputizer, dp)).to eq false
    end
  end
end
