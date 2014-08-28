require "rails_helper"

module Api::V1
  RSpec.describe "ListReaders", :type => :request do
    describe "GET /list_readers" do
      it "works! (now write some real specs)" do
        get list_readers_path
        expect(response.status).to be(200)
      end
    end
  end
end
