require "rails_helper"

module Api::V1
  RSpec.describe "Collaborators", :type => :request do
    describe "GET /collaborators" do
      it "works! (now write some real specs)" do
        get collaborators_path
        expect(response.status).to be(200)
      end
    end
  end
end
