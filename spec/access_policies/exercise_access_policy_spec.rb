require 'rails_helper'

RSpec.describe ExerciseAccessPolicy, type: :access_policy do
  let(:anon)     { AnonymousUser.instance }
  let(:user)     { FactoryBot.create(:user) }
  let(:app)      { FactoryBot.create(:doorkeeper_application) }
  let(:exercise) { FactoryBot.build(:exercise) }

  context 'search' do
    it 'can be accessed by anyone' do
      expect(described_class.action_allowed?(:search, anon, Exercise)).to eq true

      expect(described_class.action_allowed?(:search, user, Exercise)).to eq true

      expect(described_class.action_allowed?(:search, app, Exercise)).to eq true
    end
  end

  context 'read' do
    before { exercise.save! }

    context 'not published' do
      it 'cannot be accessed by anonymous users, applications or users without roles' do
        expect(described_class.action_allowed?(:read, anon, exercise)).to eq false

        expect(described_class.action_allowed?(:read, app, exercise)).to eq false

        expect(described_class.action_allowed?(:read, user, exercise)).to eq false
      end

      it 'can be accessed by collaborators and their delegates' do
        author = FactoryBot.create(:author, publication: exercise.publication, user: user)
        expect(described_class.action_allowed?(:read, user, exercise.reload)).to eq true
        author.destroy

        ch = FactoryBot.create(:copyright_holder, publication: exercise.publication, user: user)
        expect(described_class.action_allowed?(:read, user, exercise.reload)).to eq true
        ch.destroy

        another_author = FactoryBot.create :author, publication: exercise.publication
        delegation = FactoryBot.create(
          :delegation, delegator: another_author.user, delegate: user, can_read: false
        )
        expect(described_class.action_allowed?(:read, user, exercise)).to eq false

        delegation.update_attribute :can_read, true
        expect(described_class.action_allowed?(:read, user, exercise)).to eq true

        another_copyright_holder = FactoryBot.create(
          :copyright_holder, publication: exercise.publication
        )
        delegation.update_attribute :delegator, another_copyright_holder.user
        expect(described_class.action_allowed?(:read, user, exercise)).to eq true

        delegation.update_attribute :can_read, false
        expect(described_class.action_allowed?(:read, user, exercise)).to eq false

        delegation.destroy
        expect(described_class.action_allowed?(:read, user, exercise)).to eq false
      end
    end

    context 'published' do
      it 'can be accessed by anyone' do
        exercise.publication.published_at = Time.now
        exercise.publication.save!

        expect(described_class.action_allowed?(:read, anon, exercise)).to eq true

        expect(described_class.action_allowed?(:read, user, exercise)).to eq true

        expect(described_class.action_allowed?(:read, app, exercise)).to eq true
      end
    end
  end

  context 'create' do
    context 'vocab exercise' do
      before { exercise.vocab_term = FactoryBot.create :vocab_term }

      it 'cannot be accessed by anyone' do
        expect(described_class.action_allowed?(:new_version, anon, exercise)).to eq false

        expect(described_class.action_allowed?(:new_version, user, exercise)).to eq false

        expect(described_class.action_allowed?(:new_version, app, exercise)).to eq false
      end

      it 'cannot be accessed even by an author' do
        author = FactoryBot.create(:author, publication: exercise.publication, user: user)
        expect(described_class.action_allowed?(:new_version, user, exercise)).to eq false
      end
    end

    context 'not vocab exercise' do
      it 'cannot be accessed by anonymous users or applications' do
        expect(described_class.action_allowed?(:create, anon, exercise)).to eq false

        expect(described_class.action_allowed?(:create, app, exercise)).to eq false
      end

      it 'can be accessed by normal users' do
        expect(described_class.action_allowed?(:create, user, exercise)).to eq true
      end
    end
  end

  context 'update, destroy' do
    before { exercise.save! }

    context 'vocab' do
      before { exercise.vocab_term = FactoryBot.create :vocab_term }

      it 'cannot be accessed by anyone' do
        expect(described_class.action_allowed?(:update, anon, exercise)).to eq false
        expect(described_class.action_allowed?(:destroy, anon, exercise)).to eq false

        expect(described_class.action_allowed?(:update, user, exercise)).to eq false
        expect(described_class.action_allowed?(:destroy, user, exercise)).to eq false

        expect(described_class.action_allowed?(:update, app, exercise)).to eq false
        expect(described_class.action_allowed?(:destroy, app, exercise)).to eq false
      end
      it 'can be accessed by an author' do
        author = FactoryBot.create(:author, publication: exercise.publication, user: user)
        expect(described_class.action_allowed?(:update, user, exercise)).to eq true
        expect(described_class.action_allowed?(:destroy, user, exercise)).to eq true
      end
    end

    context 'not vocab' do
      context 'not published' do
        it 'cannot be accessed by anonymous users, applications or users without roles' do
          expect(described_class.action_allowed?(:update, anon, exercise)).to eq false
          expect(described_class.action_allowed?(:destroy, anon, exercise)).to eq false

          expect(described_class.action_allowed?(:update, app, exercise)).to eq false
          expect(described_class.action_allowed?(:destroy, app, exercise)).to eq false

          expect(described_class.action_allowed?(:update, user, exercise)).to eq false
          expect(described_class.action_allowed?(:destroy, user, exercise)).to eq false
        end

        it 'can be accessed by collaborators and their delegates' do
          author = FactoryBot.create(:author, publication: exercise.publication, user: user)
          expect(described_class.action_allowed?(:update, user, exercise.reload)).to eq true
          expect(described_class.action_allowed?(:destroy, user, exercise)).to eq true
          author.destroy

          ch = FactoryBot.create(:copyright_holder, publication: exercise.publication, user: user)
          expect(described_class.action_allowed?(:update, user, exercise.reload)).to eq true
          expect(described_class.action_allowed?(:destroy, user, exercise)).to eq true
          ch.destroy

          another_author = FactoryBot.create :author, publication: exercise.publication
          delegation = FactoryBot.create(
            :delegation, delegator: another_author.user, delegate: user, can_update: false
          )
          expect(described_class.action_allowed?(:update, user, exercise)).to eq false
          expect(described_class.action_allowed?(:destroy, user, exercise)).to eq false

          delegation.update_attribute :can_update, true
          expect(described_class.action_allowed?(:update, user, exercise)).to eq true
          expect(described_class.action_allowed?(:destroy, user, exercise)).to eq true

          another_copyright_holder = FactoryBot.create(
            :copyright_holder, publication: exercise.publication
          )
          delegation.update_attribute :delegator, another_copyright_holder.user
          expect(described_class.action_allowed?(:update, user, exercise)).to eq true
          expect(described_class.action_allowed?(:destroy, user, exercise)).to eq true

          delegation.update_attribute :can_update, false
          expect(described_class.action_allowed?(:update, user, exercise)).to eq false
          expect(described_class.action_allowed?(:destroy, user, exercise)).to eq false

          delegation.destroy
          expect(described_class.action_allowed?(:update, user, exercise)).to eq false
          expect(described_class.action_allowed?(:destroy, user, exercise)).to eq false
        end
      end
    end

    context 'published' do
      it 'cannot be accessed by anyone' do
        FactoryBot.create(:author, publication: exercise.publication, user: user)
        FactoryBot.create(:copyright_holder, publication: exercise.publication, user: user)

        exercise.publication.published_at = Time.now
        exercise.publication.save!

        expect(described_class.action_allowed?(:update, anon, exercise)).to eq false
        expect(described_class.action_allowed?(:destroy, anon, exercise)).to eq false

        expect(described_class.action_allowed?(:update, user, exercise)).to eq false
        expect(described_class.action_allowed?(:destroy, user, exercise)).to eq false

        expect(described_class.action_allowed?(:update, app, exercise)).to eq false
        expect(described_class.action_allowed?(:destroy, app, exercise)).to eq false
      end
    end
  end

  context 'new_version' do
    before { exercise.save! }

    context 'vocab' do
      before do
        exercise.vocab_term = FactoryBot.create :vocab_term
        exercise.publication.published_at = Time.now
        exercise.publication.save!
        exercise.save!
      end

      it 'cannot be accessed by anyone' do
        expect(described_class.action_allowed?(:new_version, anon, exercise)).to eq false

        expect(described_class.action_allowed?(:new_version, user, exercise)).to eq false

        expect(described_class.action_allowed?(:new_version, app, exercise)).to eq false
      end
      it 'can be accessed by an author' do
        author = FactoryBot.create(:author, publication: exercise.publication, user: user)
        expect(described_class.action_allowed?(:new_version, user, exercise.reload)).to eq true
      end
    end

    context 'not vocab' do
      context 'published' do
        before do
          exercise.publication.published_at = Time.now
          exercise.publication.save!
        end

        it 'cannot be accessed by anonymous users, applications or users without roles' do
          expect(described_class.action_allowed?(:new_version, anon, exercise)).to eq false

          expect(described_class.action_allowed?(:new_version, app, exercise)).to eq false

          expect(described_class.action_allowed?(:new_version, user, exercise)).to eq false
        end

        it 'can be accessed by collaborators and their delegates' do
          author = FactoryBot.create(:author, publication: exercise.publication, user: user)
          expect(described_class.action_allowed?(:new_version, user, exercise.reload)).to eq true
          author.destroy

          ch = FactoryBot.create(:copyright_holder, publication: exercise.publication, user: user)
          expect(described_class.action_allowed?(:new_version, user, exercise.reload)).to eq true
          ch.destroy

          another_author = FactoryBot.create :author, publication: exercise.publication
          delegation = FactoryBot.create(
            :delegation, delegator: another_author.user, delegate: user, can_update: false
          )
          expect(described_class.action_allowed?(:new_version, user, exercise)).to eq false

          delegation.update_attribute :can_update, true
          expect(described_class.action_allowed?(:new_version, user, exercise)).to eq true

          another_copyright_holder = FactoryBot.create(
            :copyright_holder, publication: exercise.publication
          )
          delegation.update_attribute :delegator, another_copyright_holder.user
          expect(described_class.action_allowed?(:new_version, user, exercise)).to eq true

          delegation.update_attribute :can_update, false
          expect(described_class.action_allowed?(:new_version, user, exercise)).to eq false

          delegation.destroy
          expect(described_class.action_allowed?(:new_version, user, exercise)).to eq false
        end
      end

      context 'not published' do
        it 'cannot be accessed by anyone' do
          expect(described_class.action_allowed?(:new_version, anon, exercise)).to eq false

          expect(described_class.action_allowed?(:new_version, user, exercise)).to eq false

          expect(described_class.action_allowed?(:new_version, app, exercise)).to eq false
        end
      end
    end
  end

  context 'other actions' do
    it 'cannot be accessed' do
      expect(described_class.action_allowed?(:other, anon, Exercise)).to eq false
      expect(described_class.action_allowed?(:other, user, Exercise)).to eq false
      expect(described_class.action_allowed?(:other, app, Exercise)).to eq false

      expect(described_class.action_allowed?(:other, anon, exercise)).to eq false
      expect(described_class.action_allowed?(:other, user, exercise)).to eq false
      expect(described_class.action_allowed?(:other, app, exercise)).to eq false
    end
  end
end
