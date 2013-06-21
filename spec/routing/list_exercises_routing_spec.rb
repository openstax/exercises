require "spec_helper"

describe ListExercisesController do
  describe "routing" do

    it "routes to #index" do
      get("/list_exercises").should route_to("list_exercises#index")
    end

    it "routes to #new" do
      get("/list_exercises/new").should route_to("list_exercises#new")
    end

    it "routes to #show" do
      get("/list_exercises/1").should route_to("list_exercises#show", :id => "1")
    end

    it "routes to #edit" do
      get("/list_exercises/1/edit").should route_to("list_exercises#edit", :id => "1")
    end

    it "routes to #create" do
      post("/list_exercises").should route_to("list_exercises#create")
    end

    it "routes to #update" do
      put("/list_exercises/1").should route_to("list_exercises#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/list_exercises/1").should route_to("list_exercises#destroy", :id => "1")
    end

  end
end
