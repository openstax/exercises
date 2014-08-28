require 'rails_helper'

module Admin
  RSpec.describe "Languages", :type => :request do
    describe "GET /languages" do
      it "works! (now write some real specs)" do
        get languages_path
        expect(response.status).to be(200)
      end
    end
  end
end
