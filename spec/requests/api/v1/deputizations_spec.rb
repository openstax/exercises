require "rails_helper"

module Api::V1
  RSpec.describe "Deputizations", :type => :request, api: true, version: :v1 do
    describe "GET /deputizations" do
      it "works! (now write some real specs)" do
        get deputizations_path
        expect(response.status).to be(200)
      end
    end
  end
end
