require "spec_helper"

describe LibrariesController do
  describe "routing" do

    it "routes to #index" do
      get("/libraries").should route_to("libraries#index")
    end

    it "routes to #new" do
      get("/libraries/new").should route_to("libraries#new")
    end

    it "routes to #show" do
      get("/libraries/1").should route_to("libraries#show", :id => "1")
    end

    it "routes to #edit" do
      get("/libraries/1/edit").should route_to("libraries#edit", :id => "1")
    end

    it "routes to #create" do
      post("/libraries").should route_to("libraries#create")
    end

    it "routes to #update" do
      put("/libraries/1").should route_to("libraries#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/libraries/1").should route_to("libraries#destroy", :id => "1")
    end

  end
end
