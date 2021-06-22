require 'rails_helper'

RSpec.describe ListPublicationGroupAccessPolicy, type: :access_policy do
  let(:anon)                   { AnonymousUser.instance }
  let(:user)                   { FactoryBot.create(:user) }
  let(:app)                    { FactoryBot.create(:doorkeeper_application) }
  let(:list)                   { FactoryBot.create(:list) }
  let(:list_publication_group) { FactoryBot.build(:list_publication_group, list: list) }

  context 'create, destroy' do
    it 'cannot be accessed by anonymous users, applications or users without roles' do
      expect(described_class.action_allowed?(:create, anon, list_publication_group)).to eq false
      expect(described_class.action_allowed?(:destroy, anon, list_publication_group)).to eq false

      expect(described_class.action_allowed?(:create, app, list_publication_group)).to eq false
      expect(described_class.action_allowed?(:destroy, app, list_publication_group)).to eq false

      expect(described_class.action_allowed?(:create, user, list_publication_group)).to eq false
      expect(described_class.action_allowed?(:destroy, user, list_publication_group)).to eq false
    end

    it 'can be accessed by list collaborators and owners' do
      author = FactoryBot.create(:author, publication: list.publication, user: user)
      list.reload
      expect(described_class.action_allowed?(:create, user, list_publication_group)).to eq true
      expect(described_class.action_allowed?(:destroy, user, list_publication_group)).to eq true
      author.destroy

      ch = FactoryBot.create(:copyright_holder, publication: list.publication, user: user)
      list.reload
      expect(described_class.action_allowed?(:create, user, list_publication_group)).to eq true
      expect(described_class.action_allowed?(:destroy, user, list_publication_group)).to eq true
      ch.destroy

      lo = FactoryBot.create(:list_owner, list: list, owner: user)
      list.reload
      expect(described_class.action_allowed?(:create, user, list_publication_group)).to eq true
      expect(described_class.action_allowed?(:destroy, user, list_publication_group)).to eq true
      lo.destroy

      le = FactoryBot.create(:list_editor, list: list, editor: user)
      list.reload
      expect(described_class.action_allowed?(:create, user, list_publication_group)).to eq false
      expect(described_class.action_allowed?(:destroy, user, list_publication_group)).to eq false
      le.destroy

      lr = FactoryBot.create(:list_reader, list: list, reader: user)
      list.reload
      expect(described_class.action_allowed?(:create, user, list_publication_group)).to eq false
      expect(described_class.action_allowed?(:destroy, user, list_publication_group)).to eq false
      lr.destroy

      list.reload
      expect(described_class.action_allowed?(:create, user, list_publication_group)).to eq false
      expect(described_class.action_allowed?(:destroy, user, list_publication_group)).to eq false
    end
  end

  context 'other actions' do
    it 'cannot be accessed' do
      expect(described_class.action_allowed?(:other, anon, ListPublicationGroup)).to eq false
      expect(described_class.action_allowed?(:other, user, ListPublicationGroup)).to eq false
      expect(described_class.action_allowed?(:other, app, ListPublicationGroup)).to eq false

      expect(described_class.action_allowed?(:other, anon, list_publication_group)).to eq false
      expect(described_class.action_allowed?(:other, user, list_publication_group)).to eq false
      expect(described_class.action_allowed?(:other, app, list_publication_group)).to eq false
    end
  end
end
