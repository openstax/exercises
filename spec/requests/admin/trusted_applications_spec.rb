require 'rails_helper'

module Admin
  RSpec.describe "TrustedApplications", :type => :request do
    describe "GET /trusted_applications" do
      it "works! (now write some real specs)" do
        get trusted_applications_path
        expect(response.status).to be(200)
      end
    end
  end
end
