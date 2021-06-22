require 'rails_helper'

RSpec.describe PublicationAccessPolicy, type: :access_policy do
  let(:anon)        { AnonymousUser.instance }
  let(:user)        { FactoryBot.create(:user) }
  let(:admin)       { FactoryBot.create(:user, :administrator) }
  let(:app)         { FactoryBot.create(:doorkeeper_application) }
  let(:publication) { FactoryBot.create(:publication) }

  context 'publish' do
    context 'published' do
      before{ publication.publish.save! }

      it 'cannot be accessed by anyone' do
        expect(described_class.action_allowed?(:publish, anon, publication)).to eq false
        expect(described_class.action_allowed?(:publish, user, publication)).to eq false
        expect(described_class.action_allowed?(:publish, app, publication)).to eq false
      end
    end

    it 'can be accessed by collaborators and their delegates' do
      author = FactoryBot.create(:author, publication: publication, user: user)
      expect(described_class.action_allowed?(:publish, user, publication.reload)).to eq true
      author.destroy

      ch = FactoryBot.create(:copyright_holder, publication: publication, user: user)
      expect(described_class.action_allowed?(:publish, user, publication.reload)).to eq true
      ch.destroy

      another_author = FactoryBot.create :author, publication: publication
      delegation = FactoryBot.create(
        :delegation, delegator: another_author.user, delegate: user, can_update: false
      )
      expect(described_class.action_allowed?(:publish, user, publication)).to eq false

      delegation.update_attribute :can_update, true
      expect(described_class.action_allowed?(:publish, user, publication)).to eq true

      another_copyright_holder = FactoryBot.create(:copyright_holder, publication: publication)
      delegation.update_attribute :delegator, another_copyright_holder.user
      expect(described_class.action_allowed?(:publish, user, publication)).to eq true

      delegation.update_attribute :can_update, false
      expect(described_class.action_allowed?(:publish, user, publication)).to eq false

      delegation.destroy
      expect(described_class.action_allowed?(:publish, user, publication)).to eq false
    end
  end

  context 'other actions' do
    it 'cannot be accessed' do
      expect(described_class.action_allowed?(:other, anon, Publication)).to eq false
      expect(described_class.action_allowed?(:other, user, Publication)).to eq false
      expect(described_class.action_allowed?(:other, app, Publication)).to eq false

      expect(described_class.action_allowed?(:other, anon, publication)).to eq false
      expect(described_class.action_allowed?(:other, user, publication)).to eq false
      expect(described_class.action_allowed?(:other, app, publication)).to eq false
    end
  end
end
