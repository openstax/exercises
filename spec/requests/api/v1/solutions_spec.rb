require "rails_helper"

module Api::V1
  RSpec.describe "Solutions", :type => :request, api: true, version: :v1 do
    describe "GET /solutions" do
      it "works! (now write some real specs)" do
        get solutions_path
        expect(response.status).to be(200)
      end
    end
  end
end
