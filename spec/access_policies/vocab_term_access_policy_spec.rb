require 'rails_helper'

RSpec.describe VocabTermAccessPolicy, type: :access_policy do
  let!(:anon)       { AnonymousUser.instance }
  let!(:user)       { FactoryGirl.create(:user) }
  let!(:app)        { FactoryGirl.create(:doorkeeper_application) }
  let!(:vocab_term) { FactoryGirl.build(:vocab_term) }

  context 'search' do
    it 'can be accessed by everyone' do
      expect(described_class.action_allowed?(:search, anon, VocabTerm)).to eq true

      expect(described_class.action_allowed?(:search, user, VocabTerm)).to eq true

      expect(described_class.action_allowed?(:search, app, VocabTerm)).to eq true
    end
  end

  context 'read' do
    before(:each) do
      vocab_term.save!
    end

    it 'cannot be accessed by anonymous users, applications or human users without roles' do
      expect(described_class.action_allowed?(:read, anon, vocab_term)).to eq false

      expect(described_class.action_allowed?(:read, app, vocab_term)).to eq false

      expect(described_class.action_allowed?(:read, user, vocab_term)).to eq false
    end

    it 'can be accessed by humans editors, authors and copyright holders' do
      editor = FactoryGirl.create(:editor, publication: vocab_term.publication, user: user)
      expect(described_class.action_allowed?(:read, user, vocab_term.reload)).to eq true
      editor.destroy

      author = FactoryGirl.create(:author, publication: vocab_term.publication, user: user)
      expect(described_class.action_allowed?(:read, user, vocab_term.reload)).to eq true
      author.destroy

      ch = FactoryGirl.create(:copyright_holder, publication: vocab_term.publication, user: user)
      expect(described_class.action_allowed?(:read, user, vocab_term.reload)).to eq true
      ch.destroy

      expect(described_class.action_allowed?(:read, user, vocab_term.reload)).to eq false
    end
  end

  context 'create' do
    context 'not created' do
      it 'cannot be accessed by anonymous users or applications' do
        expect(described_class.action_allowed?(:create, anon, vocab_term)).to eq false

        expect(described_class.action_allowed?(:create, app, vocab_term)).to eq false
      end

      it 'can be accessed by humans users' do
        expect(described_class.action_allowed?(:create, user, vocab_term)).to eq true
      end
    end

    context 'created' do
      it 'cannot be accessed by anyone' do
        vocab_term.save!
        FactoryGirl.create(:editor, publication: vocab_term.publication, user: user)
        FactoryGirl.create(:author, publication: vocab_term.publication, user: user)
        FactoryGirl.create(:copyright_holder, publication: vocab_term.publication, user: user)

        expect(described_class.action_allowed?(:create, anon, vocab_term)).to eq false

        expect(described_class.action_allowed?(:create, user, vocab_term)).to eq false

        expect(described_class.action_allowed?(:create, app, vocab_term)).to eq false
      end
    end
  end

  context 'update and destroy' do
    before(:each) do
      vocab_term.save!
    end

    context 'not published' do
      it 'cannot be accessed by anonymous users, applications or human users without roles' do
        expect(described_class.action_allowed?(:update, anon, vocab_term)).to eq false
        expect(described_class.action_allowed?(:destroy, anon, vocab_term)).to eq false

        expect(described_class.action_allowed?(:update, app, vocab_term)).to eq false
        expect(described_class.action_allowed?(:destroy, app, vocab_term)).to eq false

        expect(described_class.action_allowed?(:update, user, vocab_term)).to eq false
        expect(described_class.action_allowed?(:destroy, user, vocab_term)).to eq false
      end

    it 'can be accessed by humans editors, authors and copyright holders' do
      editor = FactoryGirl.create(:editor, publication: vocab_term.publication, user: user)
      expect(described_class.action_allowed?(:update, user, vocab_term.reload)).to eq true
      expect(described_class.action_allowed?(:destroy, user, vocab_term)).to eq true
      editor.destroy

      author = FactoryGirl.create(:author, publication: vocab_term.publication, user: user)
      expect(described_class.action_allowed?(:update, user, vocab_term.reload)).to eq true
      expect(described_class.action_allowed?(:destroy, user, vocab_term)).to eq true
      author.destroy

      ch = FactoryGirl.create(:copyright_holder, publication: vocab_term.publication, user: user)
      expect(described_class.action_allowed?(:update, user, vocab_term.reload)).to eq true
      expect(described_class.action_allowed?(:destroy, user, vocab_term)).to eq true
      ch.destroy

      expect(described_class.action_allowed?(:update, user, vocab_term.reload)).to eq false
    end
    end

    context 'published' do
      it 'cannot be accessed by anyone' do
        FactoryGirl.create(:editor, publication: vocab_term.publication, user: user)
        FactoryGirl.create(:author, publication: vocab_term.publication, user: user)
        FactoryGirl.create(:copyright_holder, publication: vocab_term.publication, user: user)

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
    before(:each) do
      vocab_term.save!
    end

    context 'published' do
      before(:each) do
        vocab_term.publication.published_at = Time.now
        vocab_term.publication.save!
      end

      it 'cannot be accessed by anonymous users, applications or human users without roles' do
        expect(described_class.action_allowed?(:new_version, anon, vocab_term)).to eq false

        expect(described_class.action_allowed?(:new_version, app, vocab_term)).to eq false

        expect(described_class.action_allowed?(:new_version, user, vocab_term)).to eq false
      end

      it 'can be accessed by humans editors, authors and copyright holders' do
        editor = FactoryGirl.create(:editor, publication: vocab_term.publication, user: user)
        expect(described_class.action_allowed?(:new_version, user, vocab_term.reload)).to eq true
        editor.destroy

        author = FactoryGirl.create(:author, publication: vocab_term.publication, user: user)
        expect(described_class.action_allowed?(:new_version, user, vocab_term.reload)).to eq true
        author.destroy

        ch = FactoryGirl.create(:copyright_holder, publication: vocab_term.publication, user: user)
        expect(described_class.action_allowed?(:new_version, user, vocab_term.reload)).to eq true
        ch.destroy

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
