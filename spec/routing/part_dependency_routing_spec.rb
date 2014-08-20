require "spec_helper"

describe PartDependenciesController do
  describe "routing" do

    it "routes to #index" do
      get("/part_dependencies").should route_to("part_dependencies#index")
    end

    it "routes to #new" do
      get("/part_dependencies/new").should route_to("part_dependencies#new")
    end

    it "routes to #show" do
      get("/part_dependencies/1").should route_to("part_dependencies#show", :id => "1")
    end

    it "routes to #edit" do
      get("/part_dependencies/1/edit").should route_to("part_dependencies#edit", :id => "1")
    end

    it "routes to #create" do
      post("/part_dependencies").should route_to("part_dependencies#create")
    end

    it "routes to #update" do
      put("/part_dependencies/1").should route_to("part_dependencies#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/part_dependencies/1").should route_to("part_dependencies#destroy", :id => "1")
    end

  end
end
