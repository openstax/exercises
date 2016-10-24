require 'rails_helper'

RSpec.describe PublicationAccessPolicy, type: :access_policy do
  let(:anon)        { AnonymousUser.instance }
  let(:user)        { FactoryGirl.create(:user) }
  let(:admin)       { FactoryGirl.create(:user, :administrator) }
  let(:application) { FactoryGirl.create(:doorkeeper_application) }

  context 'publish' do
    context 'published' do
      it 'cannot be accessed by anyone' do
      end
    end

    it 'can be accessed by collaborators and also ' +
       'list owners and editors if a collaborator is a list owner' do

    end
  end

  context 'other actions' do
    it 'cannot be accessed' do
    end
  end
end
