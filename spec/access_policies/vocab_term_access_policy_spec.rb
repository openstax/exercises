require 'rails_helper'

RSpec.describe VocabTermAccessPolicy, type: :access_policy do
  let(:anon)       { AnonymousUser.instance }
  let(:user)       { FactoryBot.create(:user) }
  let(:app)        { FactoryBot.create(:doorkeeper_application) }
  let(:vocab_term) { FactoryBot.build(:vocab_term) }

  context 'search' do
    it 'can be accessed by anyone' do
      expect(described_class.action_allowed?(:search, anon, VocabTerm)).to eq true

      expect(described_class.action_allowed?(:search, user, VocabTerm)).to eq true

      expect(described_class.action_allowed?(:search, app, VocabTerm)).to eq true
    end
  end

  context 'read' do
    before { vocab_term.save! }

    it 'cannot be accessed by anonymous users, applications or users without roles' do
      expect(described_class.action_allowed?(:read, anon, vocab_term)).to eq false

      expect(described_class.action_allowed?(:read, app, vocab_term)).to eq false

      expect(described_class.action_allowed?(:read, user, vocab_term)).to eq false
    end

    it 'can be accessed by collaborators and also ' +
       'list owners, editors and readers if a collaborator is a list owner' do
      author = FactoryBot.create(:author, publication: vocab_term.publication, user: user)
      expect(described_class.action_allowed?(:read, user, vocab_term.reload)).to eq true
      author.destroy

      ch = FactoryBot.create(:copyright_holder, publication: vocab_term.publication, user: user)
      expect(described_class.action_allowed?(:read, user, vocab_term.reload)).to eq true
      ch.destroy

      another_author = FactoryBot.create(:author, publication: vocab_term.publication)
      lpg = FactoryBot.create(:list_publication_group,
                               publication_group: vocab_term.publication_group)
      alo = FactoryBot.create(:list_owner, list: lpg.list, owner: another_author.user)

      lo = FactoryBot.create(:list_owner, list: lpg.list, owner: user)
      expect(described_class.action_allowed?(:read, user, vocab_term.reload)).to eq true
      lo.destroy

      le = FactoryBot.create(:list_editor, list: lpg.list, editor: user)
      expect(described_class.action_allowed?(:read, user, vocab_term.reload)).to eq true
      le.destroy

      lr = FactoryBot.create(:list_reader, list: lpg.list, reader: user)
      expect(described_class.action_allowed?(:read, user, vocab_term.reload)).to eq true
      lr.destroy

      expect(described_class.action_allowed?(:read, user, vocab_term.reload)).to eq false
    end
  end

  context 'create' do
    it 'cannot be accessed by anonymous users or applications' do
      expect(described_class.action_allowed?(:create, anon, vocab_term)).to eq false

      expect(described_class.action_allowed?(:create, app, vocab_term)).to eq false
    end

    it 'can be accessed by users' do
      expect(described_class.action_allowed?(:create, user, vocab_term)).to eq true
    end
  end

  context 'update and destroy' do
    before { vocab_term.save! }

    context 'not published' do
      it 'cannot be accessed by anonymous users, applications or users without roles' do
        expect(described_class.action_allowed?(:update, anon, vocab_term)).to eq false
        expect(described_class.action_allowed?(:destroy, anon, vocab_term)).to eq false

        expect(described_class.action_allowed?(:update, app, vocab_term)).to eq false
        expect(described_class.action_allowed?(:destroy, app, vocab_term)).to eq false

        expect(described_class.action_allowed?(:update, user, vocab_term)).to eq false
        expect(described_class.action_allowed?(:destroy, user, vocab_term)).to eq false
      end

      it 'can be accessed by collaborators and also ' +
         'list owners and editors if a collaborator is a list owner' do
        author = FactoryBot.create(:author, publication: vocab_term.publication, user: user)
        expect(described_class.action_allowed?(:update, user, vocab_term.reload)).to eq true
        expect(described_class.action_allowed?(:destroy, user, vocab_term)).to eq true
        author.destroy

        ch = FactoryBot.create(:copyright_holder, publication: vocab_term.publication, user: user)
        expect(described_class.action_allowed?(:update, user, vocab_term.reload)).to eq true
        expect(described_class.action_allowed?(:destroy, user, vocab_term)).to eq true
        ch.destroy

        another_author = FactoryBot.create(:author, publication: vocab_term.publication)
        lpg = FactoryBot.create(:list_publication_group,
                                 publication_group: vocab_term.publication_group)
        alo = FactoryBot.create(:list_owner, list: lpg.list, owner: another_author.user)

        lo = FactoryBot.create(:list_owner, list: lpg.list, owner: user)
        expect(described_class.action_allowed?(:update, user, vocab_term.reload)).to eq true
        expect(described_class.action_allowed?(:destroy, user, vocab_term)).to eq true
        lo.destroy

        le = FactoryBot.create(:list_editor, list: lpg.list, editor: user)
        expect(described_class.action_allowed?(:update, user, vocab_term.reload)).to eq true
        expect(described_class.action_allowed?(:destroy, user, vocab_term)).to eq true
        le.destroy

        lr = FactoryBot.create(:list_reader, list: lpg.list, reader: user)
        expect(described_class.action_allowed?(:update, user, vocab_term.reload)).to eq false
        expect(described_class.action_allowed?(:destroy, user, vocab_term)).to eq false
        lr.destroy

        expect(described_class.action_allowed?(:update, user, vocab_term.reload)).to eq false
      end
    end

    context 'published' do
      it 'cannot be accessed by anyone' do
        FactoryBot.create(:author, publication: vocab_term.publication, user: user)
        FactoryBot.create(:copyright_holder, publication: vocab_term.publication, user: user)

        vocab_term.publication.published_at = Time.now
        vocab_term.publication.save!

        expect(described_class.action_allowed?(:update, anon, vocab_term)).to eq false
        expect(described_class.action_allowed?(:destroy, anon, vocab_term)).to eq false

        expect(described_class.action_allowed?(:update, user, vocab_term)).to eq false
        expect(described_class.action_allowed?(:destroy, user, vocab_term)).to eq false

        expect(described_class.action_allowed?(:update, app, vocab_term)).to eq false
        expect(described_class.action_allowed?(:destroy, app, vocab_term)).to eq false
      end
    end
  end

  context 'new_version' do
    before { vocab_term.save! }

    context 'published' do
      before do
        vocab_term.publication.published_at = Time.now
        vocab_term.publication.save!
      end

      it 'cannot be accessed by anonymous users, applications or users without roles' do
        expect(described_class.action_allowed?(:new_version, anon, vocab_term)).to eq false

        expect(described_class.action_allowed?(:new_version, app, vocab_term)).to eq false

        expect(described_class.action_allowed?(:new_version, user, vocab_term)).to eq false
      end

      it 'can be accessed by collaborators and also ' +
         'list owners and editors if a collaborator is a list owner' do
        author = FactoryBot.create(:author, publication: vocab_term.publication, user: user)
        expect(described_class.action_allowed?(:new_version, user, vocab_term.reload)).to eq true
        author.destroy

        ch = FactoryBot.create(:copyright_holder, publication: vocab_term.publication, user: user)
        expect(described_class.action_allowed?(:new_version, user, vocab_term.reload)).to eq true
        ch.destroy

        another_author = FactoryBot.create(:author, publication: vocab_term.publication)
        lpg = FactoryBot.create(:list_publication_group,
                                 publication_group: vocab_term.publication_group)
        alo = FactoryBot.create(:list_owner, list: lpg.list, owner: another_author.user)

        lo = FactoryBot.create(:list_owner, list: lpg.list, owner: user)
        expect(described_class.action_allowed?(:new_version, user, vocab_term.reload)).to eq true
        lo.destroy

        le = FactoryBot.create(:list_editor, list: lpg.list, editor: user)
        expect(described_class.action_allowed?(:new_version, user, vocab_term.reload)).to eq true
        le.destroy

        lr = FactoryBot.create(:list_reader, list: lpg.list, reader: user)
        expect(described_class.action_allowed?(:new_version, user, vocab_term.reload)).to eq false
        lr.destroy

        expect(described_class.action_allowed?(:new_version, user, vocab_term.reload)).to eq false
      end
    end

    context 'not published' do
      it 'cannot be accessed by anyone' do
        expect(described_class.action_allowed?(:new_version, anon, vocab_term)).to eq false

        expect(described_class.action_allowed?(:new_version, user, vocab_term)).to eq false

        expect(described_class.action_allowed?(:new_version, app, vocab_term)).to eq false
      end
    end
  end

  context 'other actions' do
    it 'cannot be accessed' do
      expect(OSU::AccessPolicy.action_allowed?(:other, anon, VocabTerm)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, user, VocabTerm)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, app, VocabTerm)).to eq false

      expect(OSU::AccessPolicy.action_allowed?(:other, anon, vocab_term)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, user, vocab_term)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, app, vocab_term)).to eq false
    end
  end
end
