require "rails_helper"

module Api::V1
  RSpec.describe "Users", :type => :request, api: true, version: :v1 do
    describe "GET /users" do
      it "works! (now write some real specs)" do
        get users_path
        expect(response.status).to be(200)
      end
    end
  end
end
