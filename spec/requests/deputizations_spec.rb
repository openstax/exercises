require "rails_helper"

RSpec.describe "Deputizations", :type => :request do
  describe "GET /deputizations" do
    it "works! (now write some real specs)" do
      get deputizations_path
      expect(response.status).to be(200)
    end
  end
end