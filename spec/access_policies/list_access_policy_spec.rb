require 'rails_helper'

RSpec.describe ListAccessPolicy, type: :access_policy do
  let(:anon) { AnonymousUser.instance }
  let(:user) { FactoryBot.create(:user) }
  let(:app)  { FactoryBot.create(:doorkeeper_application) }
  let(:list) { FactoryBot.build(:list) }

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

    it 'can be accessed by collaborators and their delegates' do
      author = FactoryBot.create(:author, publication: list.publication, user: user)
      expect(described_class.action_allowed?(:read, user, list.reload)).to eq true
      author.destroy

      ch = FactoryBot.create(:copyright_holder, publication: list.publication, user: user)
      expect(described_class.action_allowed?(:read, user, list.reload)).to eq true
      ch.destroy

      another_author = FactoryBot.create :author, publication: list.publication
      delegation = FactoryBot.create(
        :delegation, delegator: another_author.user, delegate: user, can_read: false
      )
      expect(described_class.action_allowed?(:read, user, list)).to eq false

      delegation.update_attribute :can_read, true
      expect(described_class.action_allowed?(:read, user, list)).to eq true

      another_copyright_holder = FactoryBot.create(
        :copyright_holder, publication: list.publication
      )
      delegation.update_attribute :delegator, another_copyright_holder.user
      expect(described_class.action_allowed?(:read, user, list)).to eq true

      delegation.update_attribute :can_read, false
      expect(described_class.action_allowed?(:read, user, list)).to eq false

      delegation.destroy
      expect(described_class.action_allowed?(:read, user, list)).to eq false
    end
  end

  context 'create' do
    it 'cannot be accessed by anonymous users or applications' do
      expect(described_class.action_allowed?(:create, anon, list)).to eq false

      expect(described_class.action_allowed?(:create, app, list)).to eq false
    end

    it 'can be accessed by normal users' do
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

      it 'can be accessed by collaborators and their delegates' do
        author = FactoryBot.create(:author, publication: list.publication, user: user)
        expect(described_class.action_allowed?(:update, user, list.reload)).to eq true
        expect(described_class.action_allowed?(:destroy, user, list)).to eq true
        author.destroy

        ch = FactoryBot.create(:copyright_holder, publication: list.publication, user: user)
        expect(described_class.action_allowed?(:update, user, list.reload)).to eq true
        expect(described_class.action_allowed?(:destroy, user, list)).to eq true
        ch.destroy

        another_author = FactoryBot.create :author, publication: list.publication
        delegation = FactoryBot.create(
          :delegation, delegator: another_author.user, delegate: user, can_update: false
        )
        expect(described_class.action_allowed?(:update, user, list)).to eq false
        expect(described_class.action_allowed?(:destroy, user, list)).to eq false

        delegation.update_attribute :can_update, true
        expect(described_class.action_allowed?(:update, user, list)).to eq true
        expect(described_class.action_allowed?(:destroy, user, list)).to eq true

        another_copyright_holder = FactoryBot.create(
          :copyright_holder, publication: list.publication
        )
        delegation.update_attribute :delegator, another_copyright_holder.user
        expect(described_class.action_allowed?(:update, user, list)).to eq true
        expect(described_class.action_allowed?(:destroy, user, list)).to eq true

        delegation.update_attribute :can_update, false
        expect(described_class.action_allowed?(:update, user, list)).to eq false
        expect(described_class.action_allowed?(:destroy, user, list)).to eq false

        delegation.destroy
        expect(described_class.action_allowed?(:update, user, list)).to eq false
        expect(described_class.action_allowed?(:destroy, user, list)).to eq false
      end
    end

    context 'published' do
      it 'cannot be accessed by anyone' do
        FactoryBot.create(:author, publication: list.publication, user: user)
        FactoryBot.create(:copyright_holder, publication: list.publication, user: user)

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

      it 'can be accessed by collaborators and their delegates' do
        author = FactoryBot.create(:author, publication: list.publication, user: user)
        expect(described_class.action_allowed?(:new_version, user, list.reload)).to eq true
        author.destroy

        ch = FactoryBot.create(:copyright_holder, publication: list.publication, user: user)
        expect(described_class.action_allowed?(:new_version, user, list.reload)).to eq true
        ch.destroy

        another_author = FactoryBot.create :author, publication: list.publication
        delegation = FactoryBot.create(
          :delegation, delegator: another_author.user, delegate: user, can_update: false
        )
        expect(described_class.action_allowed?(:new_version, user, list)).to eq false

        delegation.update_attribute :can_update, true
        expect(described_class.action_allowed?(:new_version, user, list)).to eq true

        another_copyright_holder = FactoryBot.create(
          :copyright_holder, publication: list.publication
        )
        delegation.update_attribute :delegator, another_copyright_holder.user
        expect(described_class.action_allowed?(:new_version, user, list)).to eq true

        delegation.update_attribute :can_update, false
        expect(described_class.action_allowed?(:new_version, user, list)).to eq false

        delegation.destroy
        expect(described_class.action_allowed?(:new_version, user, list)).to eq false
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
      expect(described_class.action_allowed?(:other, anon, List)).to eq false
      expect(described_class.action_allowed?(:other, user, List)).to eq false
      expect(described_class.action_allowed?(:other, app, List)).to eq false

      expect(described_class.action_allowed?(:other, anon, list)).to eq false
      expect(described_class.action_allowed?(:other, user, list)).to eq false
      expect(described_class.action_allowed?(:other, app, list)).to eq false
    end
  end
end
