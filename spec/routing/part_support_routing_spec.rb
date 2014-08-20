require "spec_helper"

describe PartSupportsController do
  describe "routing" do

    it "routes to #index" do
      get("/part_supports").should route_to("part_supports#index")
    end

    it "routes to #new" do
      get("/part_supports/new").should route_to("part_supports#new")
    end

    it "routes to #show" do
      get("/part_supports/1").should route_to("part_supports#show", :id => "1")
    end

    it "routes to #edit" do
      get("/part_supports/1/edit").should route_to("part_supports#edit", :id => "1")
    end

    it "routes to #create" do
      post("/part_supports").should route_to("part_supports#create")
    end

    it "routes to #update" do
      put("/part_supports/1").should route_to("part_supports#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/part_supports/1").should route_to("part_supports#destroy", :id => "1")
    end

  end
end
