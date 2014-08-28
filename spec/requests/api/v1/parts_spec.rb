require "rails_helper"

module Api::V1
  RSpec.describe "Parts", :type => :request do
    describe "GET /parts" do
      it "works! (now write some real specs)" do
        get parts_path
        expect(response.status).to be(200)
      end
    end
  end
end
