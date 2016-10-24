require 'rails_helper'

RSpec.describe CommunitySolutionAccessPolicy, type: :access_policy do
  let(:anon)               { AnonymousUser.instance }
  let(:user)               { FactoryGirl.create(:user) }
  let(:app)                { FactoryGirl.create(:doorkeeper_application) }
  let(:community_solution) { FactoryGirl.build(:community_solution) }

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

        it 'can be accessed by collaborators and also ' +
           'list owners, editors and readers if a collaborator is a list owner' do
          author = FactoryGirl.create(:author, publication: community_solution.publication,
                                               user: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          author.destroy

          ch = FactoryGirl.create(:copyright_holder, publication: community_solution.publication,
                                                     user: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          ch.destroy

          another_author = FactoryGirl.create(:author, publication: community_solution.publication)
          lpg = FactoryGirl.create(:list_publication_group,
                                   publication_group: community_solution.publication_group)
          alo = FactoryGirl.create(:list_owner, list: lpg.list, owner: another_author.user)

          lo = FactoryGirl.create(:list_owner, list: lpg.list, owner: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          lo.destroy

          le = FactoryGirl.create(:list_editor, list: lpg.list, editor: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          le.destroy

          lr = FactoryGirl.create(:list_reader, list: lpg.list, reader: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          lr.destroy

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

        it 'can be accessed by exercise collaborators and also ' +
           'list owners, editors and readers if a collaborator is a list owner' do
          exercise = community_solution.question.exercise

          author = FactoryGirl.create(:author, publication: exercise.publication, user: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          author.destroy

          ch = FactoryGirl.create(:copyright_holder, publication: exercise.publication, user: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          ch.destroy

          another_author = FactoryGirl.create(:author, publication: exercise.publication)
          lpg = FactoryGirl.create(:list_publication_group,
                                   publication_group: exercise.publication_group)
          alo = FactoryGirl.create(:list_owner, list: lpg.list, owner: another_author.user)

          lo = FactoryGirl.create(:list_owner, list: lpg.list, owner: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          lo.destroy

          le = FactoryGirl.create(:list_editor, list: lpg.list, editor: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          le.destroy

          lr = FactoryGirl.create(:list_reader, list: lpg.list, reader: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          lr.destroy

          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to(
            eq false
          )
        end

        it 'can be accessed by community solution collaborators and also ' +
           'list owners, editors and readers if a collaborator is a list owner' do
          author = FactoryGirl.create(:author, publication: community_solution.publication,
                                               user: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          author.destroy

          ch = FactoryGirl.create(:copyright_holder, publication: community_solution.publication,
                                                     user: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          ch.destroy

          another_author = FactoryGirl.create(:author, publication: community_solution.publication)
          lpg = FactoryGirl.create(:list_publication_group,
                                   publication_group: community_solution.publication_group)
          alo = FactoryGirl.create(:list_owner, list: lpg.list, owner: another_author.user)

          lo = FactoryGirl.create(:list_owner, list: lpg.list, owner: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          lo.destroy

          le = FactoryGirl.create(:list_editor, list: lpg.list, editor: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          le.destroy

          lr = FactoryGirl.create(:list_reader, list: lpg.list, reader: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          lr.destroy

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

        it 'can be accessed by collaborators and also ' +
           'list owners, editors and readers if a collaborator is a list owner' do
          author = FactoryGirl.create(:author, publication: community_solution.publication,
                                               user: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          author.destroy

          ch = FactoryGirl.create(:copyright_holder, publication: community_solution.publication,
                                                     user: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          ch.destroy

          another_author = FactoryGirl.create(:author, publication: community_solution.publication)
          lpg = FactoryGirl.create(:list_publication_group,
                                   publication_group: community_solution.publication_group)
          alo = FactoryGirl.create(:list_owner, list: lpg.list, owner: another_author.user)

          lo = FactoryGirl.create(:list_owner, list: lpg.list, owner: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          lo.destroy

          le = FactoryGirl.create(:list_editor, list: lpg.list, editor: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          le.destroy

          lr = FactoryGirl.create(:list_reader, list: lpg.list, reader: user)
          expect(described_class.action_allowed?(:read, user, community_solution.reload)).to eq true
          lr.destroy

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
      it 'can be accessed by exercise collaborators and also ' +
         'list owners, editors and readers if a collaborator is a list owner' do
        exercise = community_solution.question.exercise

        author = FactoryGirl.create(:author, publication: exercise.publication, user: user)
        community_solution.question.reload
        expect(described_class.action_allowed?(:create, user, community_solution)).to eq true
        author.destroy

        ch = FactoryGirl.create(:copyright_holder, publication: exercise.publication, user: user)
        community_solution.question.reload
        expect(described_class.action_allowed?(:create, user, community_solution)).to eq true
        ch.destroy

        another_author = FactoryGirl.create(:author, publication: exercise.publication)
        lpg = FactoryGirl.create(:list_publication_group,
                                 publication_group: exercise.publication_group)
        alo = FactoryGirl.create(:list_owner, list: lpg.list, owner: another_author.user)

        lo = FactoryGirl.create(:list_owner, list: lpg.list, owner: user)
        community_solution.question.reload
        expect(described_class.action_allowed?(:create, user, community_solution)).to eq true
        lo.destroy

        le = FactoryGirl.create(:list_editor, list: lpg.list, editor: user)
        community_solution.question.reload
        expect(described_class.action_allowed?(:create, user, community_solution)).to eq true
        le.destroy

        lr = FactoryGirl.create(:list_reader, list: lpg.list, reader: user)
        community_solution.question.reload
        expect(described_class.action_allowed?(:create, user, community_solution)).to eq true
        lr.destroy

        community_solution.question.reload
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

      it 'can be accessed by collaborators and also ' +
         'list owners and editors if a collaborator is a list owner' do
        author = FactoryGirl.create(:author, publication: community_solution.publication,
                                             user: user)
        expect(described_class.action_allowed?(:update, user, community_solution.reload)).to eq true
        expect(described_class.action_allowed?(:destroy, user, community_solution)).to eq true
        author.destroy

        ch = FactoryGirl.create(:copyright_holder, publication: community_solution.publication,
                                                   user: user)
        expect(described_class.action_allowed?(:update, user, community_solution.reload)).to eq true
        expect(described_class.action_allowed?(:destroy, user, community_solution)).to eq true
        ch.destroy

        another_author = FactoryGirl.create(:author, publication: community_solution.publication)
        lpg = FactoryGirl.create(:list_publication_group,
                                 publication_group: community_solution.publication_group)
        alo = FactoryGirl.create(:list_owner, list: lpg.list, owner: another_author.user)

        lo = FactoryGirl.create(:list_owner, list: lpg.list, owner: user)
        expect(described_class.action_allowed?(:update, user, community_solution.reload)).to eq true
        expect(described_class.action_allowed?(:destroy, user, community_solution)).to eq true
        lo.destroy

        le = FactoryGirl.create(:list_editor, list: lpg.list, editor: user)
        expect(described_class.action_allowed?(:update, user, community_solution.reload)).to eq true
        expect(described_class.action_allowed?(:destroy, user, community_solution)).to eq true
        le.destroy

        lr = FactoryGirl.create(:list_reader, list: lpg.list, reader: user)
        expect(described_class.action_allowed?(:update, user, community_solution.reload)).to(
          eq false
        )
        expect(described_class.action_allowed?(:destroy, user, community_solution)).to eq false
        lr.destroy

        expect(described_class.action_allowed?(:update, user, community_solution.reload)).to(
          eq false
        )
      end
    end

    context 'published' do
      it 'cannot be accessed by anyone' do
        FactoryGirl.create(:author, publication: community_solution.publication, user: user)
        FactoryGirl.create(:copyright_holder, publication: community_solution.publication,
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

      it 'can be accessed by collaborators and also ' +
         'list owners and editors if a collaborator is a list owner' do
        author = FactoryGirl.create(:author, publication: community_solution.publication,
                                             user: user)
        expect(described_class.action_allowed?(:new_version, user, community_solution.reload)).to(
          eq true
        )
        author.destroy

        ch = FactoryGirl.create(:copyright_holder, publication: community_solution.publication,
                                                   user: user)
        expect(described_class.action_allowed?(:new_version, user, community_solution.reload)).to(
          eq true
        )
        ch.destroy

        another_author = FactoryGirl.create(:author, publication: community_solution.publication)
        lpg = FactoryGirl.create(:list_publication_group,
                                 publication_group: community_solution.publication_group)
        alo = FactoryGirl.create(:list_owner, list: lpg.list, owner: another_author.user)

        lo = FactoryGirl.create(:list_owner, list: lpg.list, owner: user)
        expect(described_class.action_allowed?(:new_version, user, community_solution.reload)).to(
          eq true
        )
        lo.destroy

        le = FactoryGirl.create(:list_editor, list: lpg.list, editor: user)
        expect(described_class.action_allowed?(:new_version, user, community_solution.reload)).to(
          eq true
        )
        le.destroy

        lr = FactoryGirl.create(:list_reader, list: lpg.list, reader: user)
        expect(described_class.action_allowed?(:new_version, user, community_solution.reload)).to(
          eq false
        )
        lr.destroy

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
      expect(OSU::AccessPolicy.action_allowed?(:other, anon, CommunitySolution)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, user, CommunitySolution)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, app, CommunitySolution)).to eq false

      expect(OSU::AccessPolicy.action_allowed?(:other, anon, community_solution)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, user, community_solution)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, app, community_solution)).to eq false
    end
  end
end
