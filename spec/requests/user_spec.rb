require "rails_helper"

RSpec.describe "User", :type => :request do
  describe "GET /user" do
    it "works! (now write some real specs)" do
      get user_path
      expect(response.status).to be(200)
    end
  end
end
