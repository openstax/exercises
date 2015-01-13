require 'rails_helper'

RSpec.describe ListAccessPolicy do
  let!(:anon)        { AnonymousUser.instance }
  let!(:user)        { FactoryGirl.create(:user) }
  let!(:admin)       { FactoryGirl.create(:user, :administrator) }
  let!(:application) { FactoryGirl.create(:doorkeeper_application) }

  context '' do
    xit '' do
    end
  end
end
