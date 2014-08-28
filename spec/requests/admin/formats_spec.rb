require "rails_helper"

module Admin
  RSpec.describe "Formats", :type => :request do
    describe "GET /formats" do
      it "works! (now write some real specs)" do
        get formats_path
        expect(response.status).to be(200)
      end
    end
  end
end