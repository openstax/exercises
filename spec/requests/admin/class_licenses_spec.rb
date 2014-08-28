require "rails_helper"

module Admin
  RSpec.describe "ClassLicenses", :type => :request do
    describe "GET /class_licenses" do
      it "works! (now write some real specs)" do
        get class_licenses_path
        expect(response.status).to be(200)
      end
    end
  end
end
