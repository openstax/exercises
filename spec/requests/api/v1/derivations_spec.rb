require "rails_helper"

module Api::V1
  RSpec.describe "Derivations", :type => :request do
    describe "GET /derivations" do
      it "works! (now write some real specs)" do
        get derivations_path
        expect(response.status).to be(200)
      end
    end
  end
end
