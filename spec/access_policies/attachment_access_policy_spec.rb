require 'rails_helper'

RSpec.describe ExerciseAccessPolicy, type: :access_policy do

  let(:anon)     { AnonymousUser.instance }
  let(:user)     { FactoryBot.create(:user) }
  let(:app)      { FactoryBot.create(:doorkeeper_application) }

  let(:exercise) { FactoryBot.create(:exercise) }

  context 'an attachment on an exercise' do

    let(:attachment) { FactoryBot.build :attachment, parent: exercise }

    it 'cannot be accessed by anonymous users or applications' do
      expect(AttachmentAccessPolicy.action_allowed?(:create, anon, attachment)).to eq false
    end

    it 'cannot be created by users who are not part of the exercise' do
      # not a collaborator
      expect(AttachmentAccessPolicy.action_allowed?(:create, user, attachment)).to eq false
    end

    it 'can be created by users who collaborate on the exercise' do
      FactoryBot.create(:author, publication: exercise.publication, user: user)
      attachment.parent = exercise
      expect(AttachmentAccessPolicy.action_allowed?(:create, user, attachment)).to eq true
    end

    it 'can be deleted by the exercise author' do
      attachment.save!
      expect(AttachmentAccessPolicy.action_allowed?(:destroy, user, attachment)).to eq false
      FactoryBot.create(:author, publication: attachment.parent.publication, user: user)
      attachment.parent.reload
      expect(AttachmentAccessPolicy.action_allowed?(:destroy, user, attachment)).to eq true
      attachment.destroy!
    end

  end

end
