require "rails_helper"

module Api::V1
  RSpec.describe "Libraries", :type => :request, api: true, version: :v1 do
    describe "GET /libraries" do
      it "works! (now write some real specs)" do
        get libraries_path
        expect(response.status).to be(200)
      end
    end
  end
end
