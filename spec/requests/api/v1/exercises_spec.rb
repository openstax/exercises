require "rails_helper"

module Api::V1
  RSpec.describe "Exercises", :type => :request, api: true, version: :v1 do
    describe "GET /exercises" do
      it "works! (now write some real specs)" do
        get exercises_path
        expect(response.status).to be(200)
      end
    end
  end
end
