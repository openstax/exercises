require "rails_helper"

module Api::V1
  RSpec.describe "AuthorRequests", :type => :request do
    describe "GET /author_requests" do
      it "works! (now write some real specs)" do
        get author_requests_path
        expect(response.status).to be(200)
      end
    end
  end
end
