require "rails_helper"

module Api::V1
  RSpec.describe "LogicLibraries", :type => :request do
    describe "GET /logic_libraries" do
      it "works! (now write some real specs)" do
        get logic_libraries_path
        expect(response.status).to be(200)
      end
    end
  end
end
