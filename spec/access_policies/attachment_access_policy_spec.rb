require 'rails_helper'

RSpec.describe ExerciseAccessPolicy do

  let!(:anon)     { AnonymousUser.instance }
  let!(:user)     { FactoryGirl.create(:user) }
  let!(:app)      { FactoryGirl.create(:doorkeeper_application) }

  context 'an attachment on an exercise' do

    subject(:attachment) { FactoryGirl.build :attachment }

      it 'cannot be accessed by anonymous users or applications' do
        expect(AttachmentAccessPolicy.action_allowed?(:create, anon, attachment)).to eq false
      end

      it 'can be accessed by humans users' do
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

  context 'a non-exercise attachment' do
    subject(:attachment){ FactoryGirl.create(:attachment, parent: FactoryGirl.create(:author)) }

    it 'rejects all access' do
        expect(AttachmentAccessPolicy.action_allowed?(:create, anon, attachment)).to eq false
        expect(AttachmentAccessPolicy.action_allowed?(:create, user, attachment)).to eq false
        expect(AttachmentAccessPolicy.action_allowed?(:destroy, user, attachment)).to eq false
    end

  end

end
