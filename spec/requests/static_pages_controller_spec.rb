require 'rails_helper'

RSpec.describe StaticPagesController, type: :request do
  context "GET /copyright" do
    it "returns http success" do
      get copyright_url
      expect(response).to have_http_status(:ok)
    end
  end

  context "GET /terms" do
    it "returns http success" do
      get terms_url
      expect(response).to have_http_status(:ok)
    end
  end
end
