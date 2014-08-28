require "rails_helper"

module Api::V1
  RSpec.describe "LogicVariableValues", :type => :request do
    describe "GET /logic_variable_values" do
      it "works! (now write some real specs)" do
        get logic_variable_values_path
        expect(response.status).to be(200)
      end
    end
  end
end
