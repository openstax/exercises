require 'rails_helper'

RSpec.describe BookAccessPolicy, type: :access_policy do
  let(:anon) { AnonymousUser.instance }
  let(:app)  { FactoryBot.create(:doorkeeper_application) }
  let(:user) { FactoryBot.create(:user) }

  context 'index, read' do
    it 'cannot be accessed by anonymous users or applications' do
      expect(described_class.action_allowed?(:index, anon, OpenStax::Content::Book)).to eq false
      expect(described_class.action_allowed?(:read, anon, OpenStax::Content::Book)).to eq false

      expect(described_class.action_allowed?(:index, app, OpenStax::Content::Book)).to eq false
      expect(described_class.action_allowed?(:read, app, OpenStax::Content::Book)).to eq false
    end

    it 'can be accessed by users' do
      expect(described_class.action_allowed?(:index, user, OpenStax::Content::Book)).to eq true
      expect(described_class.action_allowed?(:read, user, OpenStax::Content::Book)).to eq true
    end
  end

  context 'other actions' do
    it 'cannot be accessed' do
      expect(described_class.action_allowed?(:other, anon, OpenStax::Content::Book)).to eq false
      expect(described_class.action_allowed?(:other, app, OpenStax::Content::Book)).to eq false
      expect(described_class.action_allowed?(:other, user, OpenStax::Content::Book)).to eq false
    end
  end
end
