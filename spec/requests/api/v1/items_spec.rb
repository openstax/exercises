require "rails_helper"

module Api::V1
  RSpec.describe "Items", :type => :request do
    describe "GET /items" do
      it "works! (now write some real specs)" do
        get items_path
        expect(response.status).to be(200)
      end
    end
  end
end
