require "rails_helper"

RSpec.describe "StaticPages", :type => :request do
  describe "GET /static_pages" do
    it "works! (now write some real specs)" do
      get static_pages_path
      expect(response.status).to be(200)
    end
  end
end
