require "rails_helper"

module Api::V1
  RSpec.describe "LogicLibraryVersions", :type => :request do
    describe "GET /logic_library_versions" do
      it "works! (now write some real specs)" do
        get logic_library_versions_path
        expect(response.status).to be(200)
      end
    end
  end
end
