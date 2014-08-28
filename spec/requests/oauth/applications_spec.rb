require "rails_helper"

module Oauth
  RSpec.describe "Applications", :type => :request do
    describe "GET /applications" do
      it "works! (now write some real specs)" do
        get applications_path
        expect(response.status).to be(200)
      end
    end
  end
end
