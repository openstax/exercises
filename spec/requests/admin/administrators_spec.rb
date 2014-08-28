require "rails_helper"

module Admin
  RSpec.describe "Administrators", :type => :request do
    describe "GET /administrators" do
      it "works! (now write some real specs)" do
        get administrators_path
        expect(response.status).to be(200)
      end
    end
  end
end
