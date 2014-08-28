require "rails_helper"

module Api::V1
  RSpec.describe "Formattings", :type => :request do
    describe "GET /formattings" do
      it "works! (now write some real specs)" do
        get formattings_path
        expect(response.status).to be(200)
      end
    end
  end
end
