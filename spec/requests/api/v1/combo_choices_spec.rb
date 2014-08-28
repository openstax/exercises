require "rails_helper"

module Api::V1
  RSpec.describe "ComboChoices", :type => :request do
    describe "GET /combo_choices" do
      it "works! (now write some real specs)" do
        get combo_choices_path
        expect(response.status).to be(200)
      end
    end
  end
end
