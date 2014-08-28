require "rails_helper"

module Api::V1
  RSpec.describe "PartDependencies", :type => :request do
    describe "GET /part_dependencies" do
      it "works! (now write some real specs)" do
        get part_dependencies_path
        expect(response.status).to be(200)
      end
    end
  end
end
