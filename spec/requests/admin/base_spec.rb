require "rails_helper"

module Admin
  RSpec.describe "Base", :type => :request do
    describe "GET /admin" do
      it "works! (now write some real specs)" do
        get admin_path
        expect(response.status).to be(200)
      end
    end
  end
end
