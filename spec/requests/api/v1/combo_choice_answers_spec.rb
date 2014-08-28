require "rails_helper"

module Api::V1
  RSpec.describe "ComboChoiceAnswers", :type => :request do
    describe "GET /combo_choice_answers" do
      it "works! (now write some real specs)" do
        get combo_choice_answers_path
        expect(response.status).to be(200)
      end
    end
  end
end
