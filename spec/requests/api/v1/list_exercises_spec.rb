require "rails_helper"

module Api::V1
  RSpec.describe "ListExercises", :type => :request do
    describe "GET /list_exercises" do
      it "works! (now write some real specs)" do
        get list_exercises_path
        expect(response.status).to be(200)
      end
    end
  end
end
