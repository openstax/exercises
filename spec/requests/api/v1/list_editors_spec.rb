require "rails_helper"

module Api::V1
  RSpec.describe "ListEditors", :type => :request do
    describe "GET /list_editors" do
      it "works! (now write some real specs)" do
        get list_editors_path
        expect(response.status).to be(200)
      end
    end
  end
end
