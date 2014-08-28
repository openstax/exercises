require "rails_helper"

module Dev
  RSpec.describe "Base", :type => :request do
    describe "GET /dev" do
      it "works! (now write some real specs)" do
        get dev_path
        expect(response.status).to be(200)
      end
    end
  end
end
