require "rails_helper"

module Api::V1
  RSpec.describe "Questions", :type => :request do
    describe "GET /questions" do
      it "works! (now write some real specs)" do
        get questions_path
        expect(response.status).to be(200)
      end
    end
  end
end
