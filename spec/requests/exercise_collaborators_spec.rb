require 'spec_helper'

describe "ExerciseCollaborators" do
  describe "GET /exercise_collaborators" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get exercise_collaborators_path
      response.status.should be(200)
    end
  end
end
