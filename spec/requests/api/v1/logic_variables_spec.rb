require 'rails_helper'

module Api::V1
  RSpec.describe "LogicVariables", :type => :request do
    describe "GET /logic_variables" do
      it "works! (now write some real specs)" do
        get logic_variables_path
        expect(response.status).to be(200)
      end
    end
  end
end
