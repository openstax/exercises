require "rails_helper"

module Api::V1
  RSpec.describe "PartSupports", :type => :request do
    describe "GET /part_supports" do
      it "works! (now write some real specs)" do
        get part_supports_path
        expect(response.status).to be(200)
      end
    end
  end
end
