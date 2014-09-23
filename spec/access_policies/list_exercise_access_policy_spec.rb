require 'rails_helper'

RSpec.describe ListExerciseAccessPolicy do
  let!(:anon)        { AnonymousUser.instance }
  let!(:user)        { FactoryGirl.create(:user) }
  let!(:admin)       { FactoryGirl.create(:user, :administrator) }
  let!(:application) { FactoryGirl.create(:doorkeeper_application) }

  context '' do
    it '' do
    end
  end
end
