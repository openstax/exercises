require 'rails_helper'

RSpec.describe UserAccessPolicy, type: :access_policy do
  let(:anon) { AnonymousUser.instance }
  let(:user) { FactoryGirl.create(:user) }
  let(:app)  { FactoryGirl.create(:doorkeeper_application) }

  context 'search' do
    it 'cannot be accessed by anonymous users' do
      expect(UserAccessPolicy.action_allowed?(:search, anon, User)).to eq false
    end

    it 'can be accessed by applications and users' do
      expect(UserAccessPolicy.action_allowed?(:search, user, User)).to eq true

      expect(UserAccessPolicy.action_allowed?(:search, app, User)).to eq true
    end
  end

  context 'show, update and destroy' do
    it 'cannot be accessed by anonymous users or applications' do
      expect(UserAccessPolicy.action_allowed?(:read, anon, User)).to eq false
      expect(UserAccessPolicy.action_allowed?(:update, anon, User)).to eq false
      expect(UserAccessPolicy.action_allowed?(:destroy, anon, User)).to eq false

      expect(UserAccessPolicy.action_allowed?(:read, app, user)).to eq false
      expect(UserAccessPolicy.action_allowed?(:update, app, user)).to eq false
      expect(UserAccessPolicy.action_allowed?(:destroy, app, user)).to eq false
    end

    it 'can be accessed by users' do
      expect(UserAccessPolicy.action_allowed?(:read, user, user)).to eq true
      expect(UserAccessPolicy.action_allowed?(:update, user, user)).to eq true
      expect(UserAccessPolicy.action_allowed?(:destroy, user, user)).to eq true
    end
  end

  context 'other actions' do
    it 'cannot be accessed' do
      expect(OSU::AccessPolicy.action_allowed?(:other, anon, User)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, user, User)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, app, User)).to eq false

      expect(OSU::AccessPolicy.action_allowed?(:other, anon, user)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, user, user)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, app, user)).to eq false
    end
  end
end
