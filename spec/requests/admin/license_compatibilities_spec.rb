require "rails_helper"

module Admin
  RSpec.describe "LicenseCompatibilities", :type => :request do
    describe "GET /license_compatibilities" do
      it "works! (now write some real specs)" do
        get license_compatibilities_path
        expect(response.status).to be(200)
      end
    end
  end
end
