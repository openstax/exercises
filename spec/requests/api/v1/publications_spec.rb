require "rails_helper"

module Api::V1
  RSpec.describe "Publications", :type => :request do
    describe "GET /publications" do
      it "works! (now write some real specs)" do
        get publications_path
        expect(response.status).to be(200)
      end
    end
  end
end
