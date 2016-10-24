require 'rails_helper'

RSpec.describe ListPublicationGroupAccessPolicy, type: :access_policy do
  let(:anon)        { AnonymousUser.instance }
  let(:user)        { FactoryGirl.create(:user) }
  let(:admin)       { FactoryGirl.create(:user, :administrator) }
  let(:application) { FactoryGirl.create(:doorkeeper_application) }

  context 'create, destroy' do
    it 'can be accessed by list collaborators and owners' do
    end
  end

  context 'other actions' do
    it 'cannot be accessed' do
    end
  end
end
