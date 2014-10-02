require 'rails_helper'

RSpec.describe ExerciseAccessPolicy do
  let!(:anon)        { AnonymousUser.instance }
  let!(:user)        { FactoryGirl.create(:user) }
  let!(:application) { FactoryGirl.create(:doorkeeper_application) }
  let!(:exercise)    { FactoryGirl.build(:exercise) }

  context 'index' do
    it 'can be accessed by everyone' do
      expect(ExerciseAccessPolicy.action_allowed?(:index, anon, Exercise)).to eq true

      expect(ExerciseAccessPolicy.action_allowed?(:index, user, Exercise)).to eq true

      expect(ExerciseAccessPolicy.action_allowed?(:index, application, Exercise)).to eq true
    end
  end

  context 'read' do
    before(:each) do
      exercise.save!
    end

    context 'not published' do
      it 'cannot be accessed by anonymous users, applications or human users without roles' do
        expect(ExerciseAccessPolicy.action_allowed?(:read, anon, exercise)).to eq false

        expect(ExerciseAccessPolicy.action_allowed?(:read, application, exercise)).to eq false

        expect(ExerciseAccessPolicy.action_allowed?(:read, user, exercise)).to eq false
      end

      it 'can be accessed by humans editors, authors and copyright holders' do
        editor = FactoryGirl.create(:editor, publication: exercise.publication, user: user)
        expect(ExerciseAccessPolicy.action_allowed?(:read, user, exercise)).to eq true
        editor.destroy
        exercise.reload

        author = FactoryGirl.create(:author, publication: exercise.publication, user: user)
        expect(ExerciseAccessPolicy.action_allowed?(:read, user, exercise)).to eq true
        author.destroy
        exercise.reload

        cr = FactoryGirl.create(:copyright_holder, publication: exercise.publication,
                                                   user: user)
        expect(ExerciseAccessPolicy.action_allowed?(:read, user, exercise)).to eq true
        cr.destroy
        exercise.reload

        expect(ExerciseAccessPolicy.action_allowed?(:read, user, exercise)).to eq false
      end
    end

    context 'published' do
      it 'can be accessed by everyone' do
        exercise.publication.published_at = Time.now
        exercise.save!

        expect(ExerciseAccessPolicy.action_allowed?(:read, anon, exercise)).to eq true

        expect(ExerciseAccessPolicy.action_allowed?(:read, user, exercise)).to eq true

        expect(ExerciseAccessPolicy.action_allowed?(:read, application, exercise)).to eq true
      end
    end
  end

  context 'create' do
    context 'not created' do
      it 'cannot be accessed by anonymous users or applications' do
        expect(ExerciseAccessPolicy.action_allowed?(:create, anon, exercise)).to eq false

        expect(ExerciseAccessPolicy.action_allowed?(:create, application, exercise)).to eq false
      end

      it 'can be accessed by humans users' do
        expect(ExerciseAccessPolicy.action_allowed?(:create, user, exercise)).to eq true
      end
    end

    context 'created' do
      it 'cannot be accessed by anyone' do
        exercise.save!
        FactoryGirl.create(:editor, publication: exercise.publication, user: user)
        FactoryGirl.create(:author, publication: exercise.publication, user: user)
        FactoryGirl.create(:copyright_holder, publication: exercise.publication, user: user)

        expect(ExerciseAccessPolicy.action_allowed?(:create, anon, exercise)).to eq false

        expect(ExerciseAccessPolicy.action_allowed?(:create, user, exercise)).to eq false

        expect(ExerciseAccessPolicy.action_allowed?(:create, application, exercise)).to eq false
      end
    end
  end

  context 'update and destroy' do
    before(:each) do
      exercise.save!
    end

    context 'not published' do
      it 'cannot be accessed by anonymous users, applications or human users without roles' do
        expect(ExerciseAccessPolicy.action_allowed?(:update, anon, exercise)).to eq false
        expect(ExerciseAccessPolicy.action_allowed?(:destroy, anon, exercise)).to eq false

        expect(ExerciseAccessPolicy.action_allowed?(:update, application, exercise)).to eq false
        expect(ExerciseAccessPolicy.action_allowed?(:destroy, application, exercise)).to eq false

        expect(ExerciseAccessPolicy.action_allowed?(:update, user, exercise)).to eq false
        expect(ExerciseAccessPolicy.action_allowed?(:destroy, user, exercise)).to eq false
      end

      it 'can be accessed by humans editors, authors and copyright holders' do
        editor = FactoryGirl.create(:editor, publication: exercise.publication, user: user)
        expect(ExerciseAccessPolicy.action_allowed?(:update, user, exercise)).to eq true
        expect(ExerciseAccessPolicy.action_allowed?(:destroy, user, exercise)).to eq true
        editor.destroy
        exercise.reload

        author = FactoryGirl.create(:author, publication: exercise.publication, user: user)
        expect(ExerciseAccessPolicy.action_allowed?(:update, user, exercise)).to eq true
        expect(ExerciseAccessPolicy.action_allowed?(:destroy, user, exercise)).to eq true
        author.destroy
        exercise.reload

        cr = FactoryGirl.create(:copyright_holder, publication: exercise.publication,
                                                   user: user)
        expect(ExerciseAccessPolicy.action_allowed?(:update, user, exercise)).to eq true
        expect(ExerciseAccessPolicy.action_allowed?(:destroy, user, exercise)).to eq true
        cr.destroy
        exercise.reload

        expect(ExerciseAccessPolicy.action_allowed?(:update, user, exercise)).to eq false
        expect(ExerciseAccessPolicy.action_allowed?(:destroy, user, exercise)).to eq false
      end
    end

    context 'published' do
      it 'cannot be accessed by anyone' do
        FactoryGirl.create(:editor, publication: exercise.publication, user: user)
        FactoryGirl.create(:author, publication: exercise.publication, user: user)
        FactoryGirl.create(:copyright_holder, publication: exercise.publication, user: user)

        exercise.publication.published_at = Time.now
        exercise.save!

        expect(ExerciseAccessPolicy.action_allowed?(:update, anon, exercise)).to eq false
        expect(ExerciseAccessPolicy.action_allowed?(:destroy, anon, exercise)).to eq false

        expect(ExerciseAccessPolicy.action_allowed?(:update, user, exercise)).to eq false
        expect(ExerciseAccessPolicy.action_allowed?(:destroy, user, exercise)).to eq false

        expect(ExerciseAccessPolicy.action_allowed?(:update, application, exercise)).to eq false
        expect(ExerciseAccessPolicy.action_allowed?(:destroy, application, exercise)).to eq false
      end
    end
  end
end
