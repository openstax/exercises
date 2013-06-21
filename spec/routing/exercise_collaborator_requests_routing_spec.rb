require "spec_helper"

describe ExerciseCollaboratorRequestsController do
  describe "routing" do

    it "routes to #index" do
      get("/exercise_collaborator_requests").should route_to("exercise_collaborator_requests#index")
    end

    it "routes to #new" do
      get("/exercise_collaborator_requests/new").should route_to("exercise_collaborator_requests#new")
    end

    it "routes to #show" do
      get("/exercise_collaborator_requests/1").should route_to("exercise_collaborator_requests#show", :id => "1")
    end

    it "routes to #edit" do
      get("/exercise_collaborator_requests/1/edit").should route_to("exercise_collaborator_requests#edit", :id => "1")
    end

    it "routes to #create" do
      post("/exercise_collaborator_requests").should route_to("exercise_collaborator_requests#create")
    end

    it "routes to #update" do
      put("/exercise_collaborator_requests/1").should route_to("exercise_collaborator_requests#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/exercise_collaborator_requests/1").should route_to("exercise_collaborator_requests#destroy", :id => "1")
    end

  end
end
