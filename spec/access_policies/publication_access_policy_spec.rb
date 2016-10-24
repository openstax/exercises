require 'rails_helper'

RSpec.describe PublicationAccessPolicy, type: :access_policy do
  let(:anon)        { AnonymousUser.instance }
  let(:user)        { FactoryGirl.create(:user) }
  let(:admin)       { FactoryGirl.create(:user, :administrator) }
  let(:app)         { FactoryGirl.create(:doorkeeper_application) }
  let(:publication) { FactoryGirl.create(:publication) }

  context 'publish' do
    context 'published' do
      before{ publication.publish.save! }

      it 'cannot be accessed by anyone' do
        expect(OSU::AccessPolicy.action_allowed?(:publish, anon, publication)).to eq false
        expect(OSU::AccessPolicy.action_allowed?(:publish, user, publication)).to eq false
        expect(OSU::AccessPolicy.action_allowed?(:publish, app, publication)).to eq false
      end
    end

    it 'can be accessed by collaborators and also ' +
       'list owners and editors if a collaborator is a list owner' do
      author = FactoryGirl.create(:author, publication: publication, user: user)
      expect(described_class.action_allowed?(:publish, user, publication.reload)).to eq true
      author.destroy

      ch = FactoryGirl.create(:copyright_holder, publication: publication, user: user)
      expect(described_class.action_allowed?(:publish, user, publication.reload)).to eq true
      ch.destroy

      another_author = FactoryGirl.create(:author, publication: publication)
      lpg = FactoryGirl.create(:list_publication_group,
                               publication_group: publication.publication_group)
      alo = FactoryGirl.create(:list_owner, list: lpg.list, owner: another_author.user)

      lo = FactoryGirl.create(:list_owner, list: lpg.list, owner: user)
      expect(described_class.action_allowed?(:publish, user, publication.reload)).to eq true
      lo.destroy

      le = FactoryGirl.create(:list_editor, list: lpg.list, editor: user)
      expect(described_class.action_allowed?(:publish, user, publication.reload)).to eq true
      le.destroy

      lr = FactoryGirl.create(:list_reader, list: lpg.list, reader: user)
      expect(described_class.action_allowed?(:publish, user, publication.reload)).to eq false
      lr.destroy

      expect(described_class.action_allowed?(:publish, user, publication.reload)).to eq false
    end
  end

  context 'other actions' do
    it 'cannot be accessed' do
      expect(OSU::AccessPolicy.action_allowed?(:other, anon, Publication)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, user, Publication)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, app, Publication)).to eq false

      expect(OSU::AccessPolicy.action_allowed?(:other, anon, publication)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, user, publication)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, app, publication)).to eq false
    end
  end
end
