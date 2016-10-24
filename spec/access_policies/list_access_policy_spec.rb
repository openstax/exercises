require 'rails_helper'

RSpec.describe ListAccessPolicy, type: :access_policy do
  let(:anon) { AnonymousUser.instance }
  let(:user) { FactoryGirl.create(:user) }
  let(:app)  { FactoryGirl.create(:doorkeeper_application) }
  let(:list) { FactoryGirl.build(:list) }

  context 'search' do
    it 'can be accessed by anyone' do
      expect(described_class.action_allowed?(:search, anon, List)).to eq true

      expect(described_class.action_allowed?(:search, user, List)).to eq true

      expect(described_class.action_allowed?(:search, app, List)).to eq true
    end
  end

  context 'read' do
    before { list.save! }

    it 'cannot be accessed by anonymous users, applications or users without roles' do
      expect(described_class.action_allowed?(:read, anon, list)).to eq false

      expect(described_class.action_allowed?(:read, app, list)).to eq false

      expect(described_class.action_allowed?(:read, user, list)).to eq false
    end

    it 'can be accessed by collaborators and also ' +
       'list owners, editors and readers if a collaborator is a list owner' do
      author = FactoryGirl.create(:author, publication: list.publication, user: user)
      expect(described_class.action_allowed?(:read, user, list.reload)).to eq true
      author.destroy

      ch = FactoryGirl.create(:copyright_holder, publication: list.publication, user: user)
      expect(described_class.action_allowed?(:read, user, list.reload)).to eq true
      ch.destroy

      another_author = FactoryGirl.create(:author, publication: list.publication)
      lpg = FactoryGirl.create(:list_publication_group, publication_group: list.publication_group)
      alo = FactoryGirl.create(:list_owner, list: lpg.list, owner: another_author.user)

      lo = FactoryGirl.create(:list_owner, list: lpg.list, owner: user)
      expect(described_class.action_allowed?(:read, user, list.reload)).to eq true
      lo.destroy

      le = FactoryGirl.create(:list_editor, list: lpg.list, editor: user)
      expect(described_class.action_allowed?(:read, user, list.reload)).to eq true
      le.destroy

      lr = FactoryGirl.create(:list_reader, list: lpg.list, reader: user)
      expect(described_class.action_allowed?(:read, user, list.reload)).to eq true
      lr.destroy

      expect(described_class.action_allowed?(:read, user, list.reload)).to eq false
    end
  end

  context 'create' do
    it 'cannot be accessed by anonymous users or applications' do
      expect(described_class.action_allowed?(:create, anon, list)).to eq false

      expect(described_class.action_allowed?(:create, app, list)).to eq false
    end

    it 'can be accessed by users' do
      expect(described_class.action_allowed?(:create, user, list)).to eq true
    end
  end

  context 'update and destroy' do
    before { list.save! }

    context 'not published' do
      it 'cannot be accessed by anonymous users, applications or users without roles' do
        expect(described_class.action_allowed?(:update, anon, list)).to eq false
        expect(described_class.action_allowed?(:destroy, anon, list)).to eq false

        expect(described_class.action_allowed?(:update, app, list)).to eq false
        expect(described_class.action_allowed?(:destroy, app, list)).to eq false

        expect(described_class.action_allowed?(:update, user, list)).to eq false
        expect(described_class.action_allowed?(:destroy, user, list)).to eq false
      end

      it 'can be accessed by collaborators and also ' +
         'list owners and editors if a collaborator is a list owner' do
        author = FactoryGirl.create(:author, publication: list.publication, user: user)
        expect(described_class.action_allowed?(:update, user, list.reload)).to eq true
        expect(described_class.action_allowed?(:destroy, user, list)).to eq true
        author.destroy

        ch = FactoryGirl.create(:copyright_holder, publication: list.publication, user: user)
        expect(described_class.action_allowed?(:update, user, list.reload)).to eq true
        expect(described_class.action_allowed?(:destroy, user, list)).to eq true
        ch.destroy

        another_author = FactoryGirl.create(:author, publication: list.publication)
        lpg = FactoryGirl.create(:list_publication_group,
                                 publication_group: list.publication_group)
        alo = FactoryGirl.create(:list_owner, list: lpg.list, owner: another_author.user)

        lo = FactoryGirl.create(:list_owner, list: lpg.list, owner: user)
        expect(described_class.action_allowed?(:update, user, list.reload)).to eq true
        expect(described_class.action_allowed?(:destroy, user, list)).to eq true
        lo.destroy

        le = FactoryGirl.create(:list_editor, list: lpg.list, editor: user)
        expect(described_class.action_allowed?(:update, user, list.reload)).to eq true
        expect(described_class.action_allowed?(:destroy, user, list)).to eq true
        le.destroy

        lr = FactoryGirl.create(:list_reader, list: lpg.list, reader: user)
        expect(described_class.action_allowed?(:update, user, list.reload)).to eq false
        expect(described_class.action_allowed?(:destroy, user, list)).to eq false
        lr.destroy

        expect(described_class.action_allowed?(:update, user, list.reload)).to eq false
      end
    end

    context 'published' do
      it 'cannot be accessed by anyone' do
        FactoryGirl.create(:author, publication: list.publication, user: user)
        FactoryGirl.create(:copyright_holder, publication: list.publication, user: user)

        list.publication.published_at = Time.now
        list.publication.save!

        expect(described_class.action_allowed?(:update, anon, list)).to eq false
        expect(described_class.action_allowed?(:destroy, anon, list)).to eq false

        expect(described_class.action_allowed?(:update, user, list)).to eq false
        expect(described_class.action_allowed?(:destroy, user, list)).to eq false

        expect(described_class.action_allowed?(:update, app, list)).to eq false
        expect(described_class.action_allowed?(:destroy, app, list)).to eq false
      end
    end
  end

  context 'new_version' do
    before { list.save! }

    context 'published' do
      before do
        list.publication.published_at = Time.now
        list.publication.save!
      end

      it 'cannot be accessed by anonymous users, applications or users without roles' do
        expect(described_class.action_allowed?(:new_version, anon, list)).to eq false

        expect(described_class.action_allowed?(:new_version, app, list)).to eq false

        expect(described_class.action_allowed?(:new_version, user, list)).to eq false
      end

      it 'can be accessed by collaborators and also ' +
         'list owners and editors if a collaborator is a list owner' do
        author = FactoryGirl.create(:author, publication: list.publication, user: user)
        expect(described_class.action_allowed?(:new_version, user, list.reload)).to eq true
        author.destroy

        ch = FactoryGirl.create(:copyright_holder, publication: list.publication, user: user)
        expect(described_class.action_allowed?(:new_version, user, list.reload)).to eq true
        ch.destroy

        another_author = FactoryGirl.create(:author, publication: list.publication)
        lpg = FactoryGirl.create(:list_publication_group,
                                 publication_group: list.publication_group)
        alo = FactoryGirl.create(:list_owner, list: lpg.list, owner: another_author.user)

        lo = FactoryGirl.create(:list_owner, list: lpg.list, owner: user)
        expect(described_class.action_allowed?(:new_version, user, list.reload)).to eq true
        lo.destroy

        le = FactoryGirl.create(:list_editor, list: lpg.list, editor: user)
        expect(described_class.action_allowed?(:new_version, user, list.reload)).to eq true
        le.destroy

        lr = FactoryGirl.create(:list_reader, list: lpg.list, reader: user)
        expect(described_class.action_allowed?(:new_version, user, list.reload)).to eq false
        lr.destroy

        expect(described_class.action_allowed?(:new_version, user, list.reload)).to eq false
      end
    end

    context 'not published' do
      it 'cannot be accessed by anyone' do
        expect(described_class.action_allowed?(:new_version, anon, list)).to eq false

        expect(described_class.action_allowed?(:new_version, user, list)).to eq false

        expect(described_class.action_allowed?(:new_version, app, list)).to eq false
      end
    end
  end

  context 'other actions' do
    it 'cannot be accessed' do
      expect(OSU::AccessPolicy.action_allowed?(:other, anon, List)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, user, List)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, app, List)).to eq false

      expect(OSU::AccessPolicy.action_allowed?(:other, anon, list)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, user, list)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, app, list)).to eq false
    end
  end
end
