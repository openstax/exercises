require "rails_helper"

module Api::V1
  RSpec.describe "Answers", :type => :request do
    describe "GET /answers" do
      it "works! (now write some real specs)" do
        get answers_path
        expect(response.status).to be(200)
      end
    end
  end
end
