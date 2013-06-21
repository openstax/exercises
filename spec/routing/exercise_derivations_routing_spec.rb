require "spec_helper"

describe ExerciseDerivationsController do
  describe "routing" do

    it "routes to #index" do
      get("/exercise_derivations").should route_to("exercise_derivations#index")
    end

    it "routes to #new" do
      get("/exercise_derivations/new").should route_to("exercise_derivations#new")
    end

    it "routes to #show" do
      get("/exercise_derivations/1").should route_to("exercise_derivations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/exercise_derivations/1/edit").should route_to("exercise_derivations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/exercise_derivations").should route_to("exercise_derivations#create")
    end

    it "routes to #update" do
      put("/exercise_derivations/1").should route_to("exercise_derivations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/exercise_derivations/1").should route_to("exercise_derivations#destroy", :id => "1")
    end

  end
end
