require 'rails_helper'

module Admin
  RSpec.describe "RequiredLibraries", :type => :request do
    describe "GET /required_libraries" do
      it "works! (now write some real specs)" do
        get required_libraries_path
        expect(response.status).to be(200)
      end
    end
  end
end
