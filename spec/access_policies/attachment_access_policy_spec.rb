require 'rails_helper'

RSpec.describe ExerciseAccessPolicy, type: :access_policy do

  let!(:anon)     { AnonymousUser.instance }
  let!(:user)     { FactoryGirl.create(:user) }
  let!(:app)      { FactoryGirl.create(:doorkeeper_application) }

  context 'an attachment on an exercise' do

    subject(:attachment) { FactoryGirl.build :attachment }

    it 'cannot be accessed by anonymous users or applications' do
      expect(AttachmentAccessPolicy.action_allowed?(:create, anon, attachment)).to eq false
    end

    it 'cannot be created by humans users who are not part of the exercise' do
      # not a collaborator
      expect(AttachmentAccessPolicy.action_allowed?(:create, user, attachment)).to eq false
    end

    it 'can be created by users who collaborate on the exercise' do
      exercise = FactoryGirl.create(:exercise)
      FactoryGirl.create(:author, publication: exercise.publication, user: user)
      attachment.parent = exercise
      expect(AttachmentAccessPolicy.action_allowed?(:create, user, attachment)).to eq true
    end

    it 'can be deleted by the exercise author' do
      attachment.save
      expect(AttachmentAccessPolicy.action_allowed?(:destroy, user, attachment)).to eq false
      FactoryGirl.create(:author, publication: attachment.parent.publication, user: user)
      attachment.parent.reload
      expect(AttachmentAccessPolicy.action_allowed?(:destroy, user, attachment)).to eq true
    end

  end

end
