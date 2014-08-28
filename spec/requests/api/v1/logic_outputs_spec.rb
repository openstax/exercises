require "rails_helper"

module Api::V1
  RSpec.describe "LogicOutputs", :type => :request do
    describe "GET /logic_outputs" do
      it "works! (now write some real specs)" do
        get logic_outputs_path
        expect(response.status).to be(200)
      end
    end
  end
end
