require 'rails_helper'

module Api::V1
  RSpec.describe "Sorts", :type => :request do
    describe "GET /sorts" do
      it "works! (now write some real specs)" do
        get sorts_path
        expect(response.status).to be(200)
      end
    end
  end
end
