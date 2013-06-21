require "spec_helper"

describe ExerciseCollaboratorsController do
  describe "routing" do

    it "routes to #index" do
      get("/exercise_collaborators").should route_to("exercise_collaborators#index")
    end

    it "routes to #new" do
      get("/exercise_collaborators/new").should route_to("exercise_collaborators#new")
    end

    it "routes to #show" do
      get("/exercise_collaborators/1").should route_to("exercise_collaborators#show", :id => "1")
    end

    it "routes to #edit" do
      get("/exercise_collaborators/1/edit").should route_to("exercise_collaborators#edit", :id => "1")
    end

    it "routes to #create" do
      post("/exercise_collaborators").should route_to("exercise_collaborators#create")
    end

    it "routes to #update" do
      put("/exercise_collaborators/1").should route_to("exercise_collaborators#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/exercise_collaborators/1").should route_to("exercise_collaborators#destroy", :id => "1")
    end

  end
end
