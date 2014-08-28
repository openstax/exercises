require "rails_helper"

module Api::V1
  RSpec.describe "Lists", :type => :request do
    describe "GET /lists" do
      it "works! (now write some real specs)" do
        get lists_path
        expect(response.status).to be(200)
      end
    end
  end
end
