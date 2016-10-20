require 'rails_helper'

RSpec.describe ExerciseAccessPolicy, type: :access_policy do
  let(:anon)     { AnonymousUser.instance }
  let(:user)     { FactoryGirl.create(:user) }
  let(:app)      { FactoryGirl.create(:doorkeeper_application) }
  let(:exercise) { FactoryGirl.build(:exercise) }

  context 'search' do
    it 'can be accessed by everyone' do
      expect(described_class.action_allowed?(:search, anon, Exercise)).to eq true

      expect(described_class.action_allowed?(:search, user, Exercise)).to eq true

      expect(described_class.action_allowed?(:search, app, Exercise)).to eq true
    end
  end

  context 'read' do
    before(:each) do
      exercise.save!
    end

    context 'not published' do
      it 'cannot be accessed by anonymous users, applications or human users without roles' do
        expect(described_class.action_allowed?(:read, anon, exercise)).to eq false

        expect(described_class.action_allowed?(:read, app, exercise)).to eq false

        expect(described_class.action_allowed?(:read, user, exercise)).to eq false
      end

      it 'can be accessed by humans authors and copyright holders' do
        author = FactoryGirl.create(:author, publication: exercise.publication, user: user)
        expect(described_class.action_allowed?(:read, user, exercise.reload)).to eq true
        author.destroy

        ch = FactoryGirl.create(:copyright_holder, publication: exercise.publication, user: user)
        expect(described_class.action_allowed?(:read, user, exercise.reload)).to eq true
        ch.destroy

        expect(described_class.action_allowed?(:read, user, exercise.reload)).to eq false
      end
    end

    context 'published' do
      it 'can be accessed by everyone' do
        exercise.publication.published_at = Time.now
        exercise.publication.save!

        expect(described_class.action_allowed?(:read, anon, exercise)).to eq true

        expect(described_class.action_allowed?(:read, user, exercise)).to eq true

        expect(described_class.action_allowed?(:read, app, exercise)).to eq true
      end
    end
  end

  context 'create' do
    context 'vocab' do
      before(:each) do
        exercise.vocab_term = FactoryGirl.create :vocab_term
      end

      it 'cannot be accessed by anyone' do
        expect(described_class.action_allowed?(:new_version, anon, exercise)).to eq false

        expect(described_class.action_allowed?(:new_version, user, exercise)).to eq false

        expect(described_class.action_allowed?(:new_version, app, exercise)).to eq false
      end
    end

    context 'not vocab' do
      context 'not created' do
        it 'cannot be accessed by anonymous users or applications' do
          expect(described_class.action_allowed?(:create, anon, exercise)).to eq false

          expect(described_class.action_allowed?(:create, app, exercise)).to eq false
        end

        it 'can be accessed by humans users' do
          expect(described_class.action_allowed?(:create, user, exercise)).to eq true
        end
      end

      context 'created' do
        it 'cannot be accessed by anyone' do
          exercise.save!
          FactoryGirl.create(:author, publication: exercise.publication, user: user)
          FactoryGirl.create(:copyright_holder, publication: exercise.publication, user: user)

          expect(described_class.action_allowed?(:create, anon, exercise)).to eq false

          expect(described_class.action_allowed?(:create, user, exercise)).to eq false

          expect(described_class.action_allowed?(:create, app, exercise)).to eq false
        end
      end
    end
  end

  context 'update and destroy' do
    before(:each) do
      exercise.save!
    end

    context 'vocab' do
      before(:each) do
        exercise.vocab_term = FactoryGirl.create :vocab_term
      end

      it 'cannot be accessed by anyone' do
        expect(described_class.action_allowed?(:new_version, anon, exercise)).to eq false

        expect(described_class.action_allowed?(:new_version, user, exercise)).to eq false

        expect(described_class.action_allowed?(:new_version, app, exercise)).to eq false
      end
    end

    context 'not vocab' do
      context 'not published' do
        it 'cannot be accessed by anonymous users, applications or human users without roles' do
          expect(described_class.action_allowed?(:update, anon, exercise)).to eq false
          expect(described_class.action_allowed?(:destroy, anon, exercise)).to eq false

          expect(described_class.action_allowed?(:update, app, exercise)).to eq false
          expect(described_class.action_allowed?(:destroy, app, exercise)).to eq false

          expect(described_class.action_allowed?(:update, user, exercise)).to eq false
          expect(described_class.action_allowed?(:destroy, user, exercise)).to eq false
        end

        it 'can be accessed by humans authors and copyright holders' do
          author = FactoryGirl.create(:author, publication: exercise.publication, user: user)
          expect(described_class.action_allowed?(:update, user, exercise.reload)).to eq true
          expect(described_class.action_allowed?(:destroy, user, exercise)).to eq true
          author.destroy

          ch = FactoryGirl.create(:copyright_holder, publication: exercise.publication, user: user)
          expect(described_class.action_allowed?(:update, user, exercise.reload)).to eq true
          expect(described_class.action_allowed?(:destroy, user, exercise)).to eq true
          ch.destroy

          expect(described_class.action_allowed?(:update, user, exercise.reload)).to eq false
          expect(described_class.action_allowed?(:destroy, user, exercise)).to eq false
        end
      end
    end

    context 'published' do
      it 'cannot be accessed by anyone' do
        FactoryGirl.create(:author, publication: exercise.publication, user: user)
        FactoryGirl.create(:copyright_holder, publication: exercise.publication, user: user)

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
    before(:each) do
      exercise.save!
    end

    context 'vocab' do
      before(:each) do
        exercise.vocab_term = FactoryGirl.create :vocab_term
        exercise.publication.published_at = Time.now
        exercise.publication.save!
      end

      it 'cannot be accessed by anyone' do
        expect(described_class.action_allowed?(:new_version, anon, exercise)).to eq false

        expect(described_class.action_allowed?(:new_version, user, exercise)).to eq false

        expect(described_class.action_allowed?(:new_version, app, exercise)).to eq false
      end
    end

    context 'not vocab' do
      context 'published' do
        before(:each) do
          exercise.publication.published_at = Time.now
          exercise.publication.save!
        end

        it 'cannot be accessed by anonymous users, applications or human users without roles' do
          expect(described_class.action_allowed?(:new_version, anon, exercise)).to eq false

          expect(described_class.action_allowed?(:new_version, app, exercise)).to eq false

          expect(described_class.action_allowed?(:new_version, user, exercise)).to eq false
        end

        it 'can be accessed by humans authors and copyright holders' do
          author = FactoryGirl.create(:author, publication: exercise.publication, user: user)
          expect(described_class.action_allowed?(:new_version, user, exercise.reload)).to eq true
          author.destroy

          ch = FactoryGirl.create(:copyright_holder, publication: exercise.publication, user: user)
          expect(described_class.action_allowed?(:new_version, user, exercise.reload)).to eq true
          ch.destroy

          expect(described_class.action_allowed?(:new_version, user, exercise.reload)).to eq false
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
      expect(OSU::AccessPolicy.action_allowed?(:other, anon, Exercise)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, user, Exercise)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, app, Exercise)).to eq false

      expect(OSU::AccessPolicy.action_allowed?(:other, anon, exercise)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, user, exercise)).to eq false
      expect(OSU::AccessPolicy.action_allowed?(:other, app, exercise)).to eq false
    end
  end
end
