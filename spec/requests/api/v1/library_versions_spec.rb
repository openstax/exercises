require "rails_helper"

module Api::V1
  RSpec.describe "LibraryVersions", :type => :request do
    describe "GET /library_versions" do
      it "works! (now write some real specs)" do
        get library_versions_path
        expect(response.status).to be(200)
      end
    end
  end
end
