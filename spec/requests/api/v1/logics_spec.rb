require "rails_helper"

module Api::V1
  RSpec.describe "Logics", :type => :request do
    describe "GET /logics" do
      it "works! (now write some real specs)" do
        get logics_path
        expect(response.status).to be(200)
      end
    end
  end
end
