require "rails_helper"

module Api::V1
  RSpec.describe "ListNestings", :type => :request do
    describe "GET /list_nestings" do
      it "works! (now write some real specs)" do
        get list_nestings_path
        expect(response.status).to be(200)
      end
    end
  end
end
