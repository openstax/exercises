require "rails_helper"

module Api::V1
  RSpec.describe "CopyrightHolderRequests", :type => :request do
    describe "GET /copyright_holder_requests" do
      it "works! (now write some real specs)" do
        get copyright_holder_requests_path
        expect(response.status).to be(200)
      end
    end
  end
end
