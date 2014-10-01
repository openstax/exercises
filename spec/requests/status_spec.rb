require "rails_helper"

RSpec.describe "status", :type => :request do
  describe "GET /status" do
    it "returns 204 No Content" do
      get '/status'
      expect(response).to have_http_status(:no_content)
    end
  end
end
