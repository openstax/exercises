require 'rails_helper'

RSpec.describe Doorkeeper::ApplicationAccessPolicy, type: :access_policy do
  let(:anon)        { AnonymousUser.instance }
  let(:user)        { FactoryBot.create(:user) }
  let(:admin)       { FactoryBot.create(:user, :administrator) }
  let(:app)         { FactoryBot.create(:doorkeeper_application) }
  let(:another_app) { FactoryBot.create(:doorkeeper_application) }

  context 'read, update' do
    it 'can be accessed by admins and application owners' do
      expect(described_class.action_allowed?(:read, admin, app)).to eq true
      expect(described_class.action_allowed?(:update, admin, app)).to eq true

      app.owner = user
      expect(described_class.action_allowed?(:read, user, app)).to eq true
      expect(described_class.action_allowed?(:update, user, app)).to eq true

      app.reload
      expect(described_class.action_allowed?(:read, user, app)).to eq false
      expect(described_class.action_allowed?(:update, user, app)).to eq false
    end

    it 'cannot be accessed by anonymous users, applications or users without roles' do
      expect(described_class.action_allowed?(:read, anon, app)).to eq false
      expect(described_class.action_allowed?(:update, anon, app)).to eq false

      expect(described_class.action_allowed?(:read, app, app)).to eq false
      expect(described_class.action_allowed?(:update, app, app)).to eq false

      expect(described_class.action_allowed?(:read, another_app, app)).to eq false
      expect(described_class.action_allowed?(:update, another_app, app)).to eq false

      expect(described_class.action_allowed?(:read, user, app)).to eq false
      expect(described_class.action_allowed?(:update, user, app)).to eq false
    end
  end

  context 'create, destroy' do
    it 'can be accessed by admins' do
      expect(described_class.action_allowed?(:create, admin, app)).to eq true
      expect(described_class.action_allowed?(:destroy, admin, app)).to eq true
    end

    it 'cannot be accessed by anyone else' do
      expect(described_class.action_allowed?(:create, anon, app)).to eq false
      expect(described_class.action_allowed?(:destroy, anon, app)).to eq false

      expect(described_class.action_allowed?(:create, app, app)).to eq false
      expect(described_class.action_allowed?(:destroy, app, app)).to eq false

      expect(described_class.action_allowed?(:create, another_app, app)).to eq false
      expect(described_class.action_allowed?(:destroy, another_app, app)).to eq false

      expect(described_class.action_allowed?(:create, user, app)).to eq false
      expect(described_class.action_allowed?(:destroy, user, app)).to eq false
    end
  end

  context 'other actions' do
    it 'cannot be accessed' do
      expect(described_class.action_allowed?(:other, anon, Doorkeeper::Application)).to eq false
      expect(described_class.action_allowed?(:other, user, Doorkeeper::Application)).to eq false
      expect(described_class.action_allowed?(:other, app, Doorkeeper::Application)).to eq false
      expect(described_class.action_allowed?(:other, another_app, Doorkeeper::Application)).to(
        eq false
      )
      expect(described_class.action_allowed?(:other, admin, Doorkeeper::Application)).to eq false

      expect(described_class.action_allowed?(:other, anon, app)).to eq false
      expect(described_class.action_allowed?(:other, user, app)).to eq false
      expect(described_class.action_allowed?(:other, app, app)).to eq false
      expect(described_class.action_allowed?(:other, another_app, app)).to eq false
      expect(described_class.action_allowed?(:other, admin, app)).to eq false
    end
  end
end
