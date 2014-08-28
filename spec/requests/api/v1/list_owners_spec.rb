require "rails_helper"

module Api::V1
  RSpec.describe "ListOwners", :type => :request do
    describe "GET /list_owners" do
      it "works! (now write some real specs)" do
        get list_owners_path
        expect(response.status).to be(200)
      end
    end
  end
end
