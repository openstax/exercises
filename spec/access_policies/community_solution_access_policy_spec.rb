require 'rails_helper'

RSpec.describe CommunitySolutionAccessPolicy, type: :access_policy do
  let(:anon)               { AnonymousUser.instance }
  let(:user)               { FactoryBot.create(:user) }
  let(:app)                { FactoryBot.create(:doorkeeper_application) }
  let(:community_solution) { FactoryBot.build(:community_solution) }

  context 'search' do
    it 'can be accessed by anyone' do
      expect(described_class.action_allowed?(:search, anon, CommunitySolution)).to eq true

      expect(described_class.action_allowed?(:search, user, CommunitySolution)).to eq true

      expect(described_class.action_allowed?(:search, app, CommunitySolution)).to eq true
    end
  end

  context 'read' do
    before { community_solution.save! }

    context 'published exercise' do
      before{ community_solution.question.exercise.publication.publish.save! }

      context 'published community solution' do
        before{ community_solution.publication.publish.save! }

        it 'can be accessed by anyone' do
          expect(described_class.action_allowed?(:read, anon, community_solution)).to eq true

          expect(described_class.action_allowed?(:read, app, community_solution)).to eq true

          expect(described_class.action_allowed?(:read, user, community_solution)).to eq true
        end
      end

      context 'unpublished community solution' do
        it 'cannot be accessed by anonymous users, applications or users without roles' do
          expect(described_class.action_allowed?(:read, anon, community_solution)).to eq false

          expect(described_class.action_allowed?(:read, app, community_solution)).to eq false

          expect(described_class.action_allowed?(:read, user, community_solution)).to eq false
        end

        it 'can be accessed by collaborators and their delegates' do
          author = FactoryBot.create(
            :author, publication: community_solution.publication, user: user
          )
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          author.destroy

          ch = FactoryBot.create(
            :copyright_holder, publication: community_solution.publication, user: user
          )
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          ch.destroy

          another_author = FactoryBot.create :author, publication: community_solution.publication
          delegation = FactoryBot.create(
            :delegation, delegator: another_author.user, delegate: user, can_read: false
          )
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to(
            eq false
          )

          delegation.update_attribute :can_read, true
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true

          another_copyright_holder = FactoryBot.create(
            :copyright_holder, publication: community_solution.publication
          )
          delegation.update_attribute :delegator, another_copyright_holder.user
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true

          delegation.destroy
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to(
            eq false
          )
        end
      end
    end

    context 'unpublished exercise' do
      context 'published community solution' do
        before{ community_solution.publication.publish.save! }

        it 'cannot be accessed by anonymous users, applications or users without roles' do
          expect(described_class.action_allowed?(:read, anon, community_solution)).to eq false

          expect(described_class.action_allowed?(:read, app, community_solution)).to eq false

          expect(described_class.action_allowed?(:read, user, community_solution)).to eq false
        end

        it 'can be accessed by exercise collaborators and their delegates' do
          exercise = community_solution.question.exercise

          author = FactoryBot.create(:author, publication: exercise.publication, user: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          author.destroy

          ch = FactoryBot.create(:copyright_holder, publication: exercise.publication, user: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          ch.destroy

          another_author = FactoryBot.create :author, publication: exercise.publication
          delegation = FactoryBot.create(
            :delegation, delegator: another_author.user, delegate: user, can_read: false
          )
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to(
            eq false
          )

          delegation.update_attribute :can_read, true
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true

          another_copyright_holder = FactoryBot.create(
            :copyright_holder, publication: exercise.publication
          )
          delegation.update_attribute :delegator, another_copyright_holder.user
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true

          delegation.update_attribute :can_read, false
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to(
            eq false
          )

          delegation.destroy
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to(
            eq false
          )
        end

        it 'can be accessed by community solution collaborators and their delegates' do
          author = FactoryBot.create(:author, publication: community_solution.publication,
                                               user: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          author.destroy

          ch = FactoryBot.create(:copyright_holder, publication: community_solution.publication,
                                                     user: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          ch.destroy

          another_author = FactoryBot.create :author, publication: community_solution.publication
          delegation = FactoryBot.create(
            :delegation, delegator: another_author.user, delegate: user, can_read: false
          )
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to(
            eq false
          )

          delegation.update_attribute :can_read, true
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true

          another_copyright_holder = FactoryBot.create(
            :copyright_holder, publication: community_solution.publication
          )
          delegation.update_attribute :delegator, another_copyright_holder.user
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true

          delegation.update_attribute :can_read, false
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to(
            eq false
          )

          delegation.destroy
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to(
            eq false
          )
        end
      end

      context 'unpublished community solution' do
        it 'cannot be accessed by anonymous users, applications or users without roles' do
          expect(described_class.action_allowed?(:read, anon, community_solution)).to eq false

          expect(described_class.action_allowed?(:read, app, community_solution)).to eq false

          expect(described_class.action_allowed?(:read, user, community_solution)).to eq false
        end

        it 'can be accessed by collaborators and their delegates' do
          author = FactoryBot.create(:author, publication: community_solution.publication,
                                               user: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          author.destroy

          ch = FactoryBot.create(:copyright_holder, publication: community_solution.publication,
                                                     user: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          ch.destroy

          another_author = FactoryBot.create :author, publication: community_solution.publication
          delegation = FactoryBot.create(
            :delegation, delegator: another_author.user, delegate: user, can_read: false
          )
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to(
            eq false
          )

          delegation.update_attribute :can_read, true
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true

          another_copyright_holder = FactoryBot.create(
            :copyright_holder, publication: community_solution.publication
          )
          delegation.update_attribute :delegator, another_copyright_holder.user
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true

          delegation.update_attribute :can_read, false
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to(
            eq false
          )

          delegation.destroy
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to(
            eq false
          )
        end
      end
    end
  end

  context 'create' do
    context 'published exercise' do
      before{ community_solution.question.exercise.publication.publish.save! }

      it 'cannot be accessed by anonymous users or applications' do
        expect(described_class.action_allowed?(:create, anon, community_solution)).to eq false

        expect(described_class.action_allowed?(:create, app, community_solution)).to eq false
      end

      it 'can be accessed by users' do
        expect(described_class.action_allowed?(:create, user, community_solution)).to eq true
      end
    end

    context 'unpublished exercise' do
      it 'can be accessed by exercise collaborators and their delegates' do
        exercise = community_solution.question.exercise

        author = FactoryBot.create(:author, publication: exercise.publication, user: user)
        community_solution.question.reload
        expect(described_class.action_allowed?(:create, user, community_solution)).to eq true
        author.destroy

        ch = FactoryBot.create(:copyright_holder, publication: exercise.publication, user: user)
        community_solution.question.reload
        expect(described_class.action_allowed?(:create, user, community_solution)).to eq true
        ch.destroy

        another_author = FactoryBot.create :author, publication: exercise.publication
        delegation = FactoryBot.create(
          :delegation, delegator: another_author.user, delegate: user, can_read: false
        )
        expect(described_class.action_allowed?(:create, user, community_solution)).to eq false

        delegation.update_attribute :can_read, true
        expect(described_class.action_allowed?(:create, user, community_solution)).to eq true

        another_copyright_holder = FactoryBot.create(
          :copyright_holder, publication: exercise.publication
        )
        delegation.update_attribute :delegator, another_copyright_holder.user
        expect(described_class.action_allowed?(:create, user, community_solution)).to eq true

        delegation.update_attribute :can_read, false
        expect(described_class.action_allowed?(:create, user, community_solution)).to eq false

        delegation.destroy
        expect(described_class.action_allowed?(:create, user, community_solution)).to eq false
      end

      it 'cannot be accessed by anonymous users, applications or users without roles' do
        expect(described_class.action_allowed?(:create, anon, community_solution)).to eq false

        expect(described_class.action_allowed?(:create, user, community_solution)).to eq false

        expect(described_class.action_allowed?(:create, app, community_solution)).to eq false
      end
    end
  end

  context 'update and destroy' do
    before { community_solution.save! }

    context 'not published' do
      it 'cannot be accessed by anonymous users, applications or users without roles' do
        expect(described_class.action_allowed?(:update, anon, community_solution)).to eq false
        expect(described_class.action_allowed?(:destroy, anon, community_solution)).to eq false

        expect(described_class.action_allowed?(:update, app, community_solution)).to eq false
        expect(described_class.action_allowed?(:destroy, app, community_solution)).to eq false

        expect(described_class.action_allowed?(:update, user, community_solution)).to eq false
        expect(described_class.action_allowed?(:destroy, user, community_solution)).to eq false
      end

      it 'can be accessed by collaborators and their delegates' do
        author = FactoryBot.create(:author, publication: community_solution.publication,
                                             user: user)
        expect(described_class.action_allowed?(:update, user, community_solution.reload)).to eq true
        expect(described_class.action_allowed?(:destroy, user, community_solution)).to eq true
        author.destroy

        ch = FactoryBot.create(:copyright_holder, publication: community_solution.publication,
                                                   user: user)
        expect(described_class.action_allowed?(:update, user, community_solution.reload)).to eq true
        expect(described_class.action_allowed?(:destroy, user, community_solution)).to eq true
        ch.destroy

        another_author = FactoryBot.create :author, publication: community_solution.publication
        delegation = FactoryBot.create(
          :delegation, delegator: another_author.user, delegate: user, can_update: false
        )
        expect(described_class.action_allowed?(:update, user, community_solution.reload)).to(
          eq false
        )
        expect(described_class.action_allowed?(:destroy, user, community_solution.reload)).to(
          eq false
        )

        delegation.update_attribute :can_update, true
        expect(described_class.action_allowed?(:update, user, community_solution.reload)).to eq true
        expect(described_class.action_allowed?(:destroy, user, community_solution.reload)).to(
          eq true
        )

        another_copyright_holder = FactoryBot.create(
          :copyright_holder, publication: community_solution.publication
        )
        delegation.update_attribute :delegator, another_copyright_holder.user
        expect(described_class.action_allowed?(:update, user, community_solution.reload)).to eq true
        expect(described_class.action_allowed?(:destroy, user, community_solution.reload)).to(
          eq true
        )

        delegation.update_attribute :can_update, false
        expect(described_class.action_allowed?(:update, user, community_solution.reload)).to(
          eq false
        )
        expect(described_class.action_allowed?(:destroy, user, community_solution.reload)).to(
          eq false
        )

        delegation.destroy
        expect(described_class.action_allowed?(:update, user, community_solution.reload)).to(
          eq false
        )
        expect(described_class.action_allowed?(:destroy, user, community_solution.reload)).to(
          eq false
        )
      end
    end

    context 'published' do
      it 'cannot be accessed by anyone' do
        FactoryBot.create(:author, publication: community_solution.publication, user: user)
        FactoryBot.create(:copyright_holder, publication: community_solution.publication,
                                              user: user)

        community_solution.publication.published_at = Time.now
        community_solution.publication.save!

        expect(described_class.action_allowed?(:update, anon, community_solution)).to eq false
        expect(described_class.action_allowed?(:destroy, anon, community_solution)).to eq false

        expect(described_class.action_allowed?(:update, user, community_solution)).to eq false
        expect(described_class.action_allowed?(:destroy, user, community_solution)).to eq false

        expect(described_class.action_allowed?(:update, app, community_solution)).to eq false
        expect(described_class.action_allowed?(:destroy, app, community_solution)).to eq false
      end
    end
  end

  context 'new_version' do
    before { community_solution.save! }

    context 'published' do
      before do
        community_solution.publication.published_at = Time.now
        community_solution.publication.save!
      end

      it 'cannot be accessed by anonymous users, applications or users without roles' do
        expect(described_class.action_allowed?(:new_version, anon, community_solution)).to eq false

        expect(described_class.action_allowed?(:new_version, app, community_solution)).to eq false

        expect(described_class.action_allowed?(:new_version, user, community_solution)).to eq false
      end

      it 'can be accessed by collaborators and their delegates' do
        author = FactoryBot.create(:author, publication: community_solution.publication,
                                             user: user)
        expect(described_class.action_allowed?(:new_version, user, community_solution.reload)).to(
          eq true
        )
        author.destroy

        ch = FactoryBot.create(:copyright_holder, publication: community_solution.publication,
                                                   user: user)
        expect(described_class.action_allowed?(:new_version, user, community_solution.reload)).to(
          eq true
        )
        ch.destroy

        another_author = FactoryBot.create :author, publication: community_solution.publication
        delegation = FactoryBot.create(
          :delegation, delegator: another_author.user, delegate: user, can_update: false
        )
        expect(described_class.action_allowed?(:new_version, user, community_solution.reload)).to(
          eq false
        )

        delegation.update_attribute :can_update, true
        expect(described_class.action_allowed?(:new_version, user, community_solution.reload)).to(
          eq true
        )

        another_copyright_holder = FactoryBot.create(
          :copyright_holder, publication: community_solution.publication
        )
        delegation.update_attribute :delegator, another_copyright_holder.user
        expect(described_class.action_allowed?(:new_version, user, community_solution.reload)).to(
          eq true
        )

        delegation.update_attribute :can_update, false
        expect(described_class.action_allowed?(:new_version, user, community_solution.reload)).to(
          eq false
        )

        delegation.destroy
        expect(described_class.action_allowed?(:new_version, user, community_solution.reload)).to(
          eq false
        )
      end
    end

    context 'not published' do
      it 'cannot be accessed by anyone' do
        expect(described_class.action_allowed?(:new_version, anon, community_solution)).to eq false

        expect(described_class.action_allowed?(:new_version, user, community_solution)).to eq false

        expect(described_class.action_allowed?(:new_version, app, community_solution)).to eq false
      end
    end
  end

  context 'other actions' do
    it 'cannot be accessed' do
      expect(described_class.action_allowed?(:other, anon, CommunitySolution)).to eq false
      expect(described_class.action_allowed?(:other, user, CommunitySolution)).to eq false
      expect(described_class.action_allowed?(:other, app, CommunitySolution)).to eq false

      expect(described_class.action_allowed?(:other, anon, community_solution)).to eq false
      expect(described_class.action_allowed?(:other, user, community_solution)).to eq false
      expect(described_class.action_allowed?(:other, app, community_solution)).to eq false
    end
  end
end
