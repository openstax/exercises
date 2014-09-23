require "rails_helper"

module Admin
  RSpec.describe "Licenses", :type => :request do
    describe "GET /licenses" do
      it "works! (now write some real specs)" do
        get licenses_path
        expect(response.status).to be(200)
      end
    end
  end
end
