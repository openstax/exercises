require "spec_helper"

describe SolutionsController do
  describe "routing" do

    it "routes to #index" do
      get("/solutions").should route_to("solutions#index")
    end

    it "routes to #new" do
      get("/solutions/new").should route_to("solutions#new")
    end

    it "routes to #show" do
      get("/solutions/1").should route_to("solutions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/solutions/1/edit").should route_to("solutions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/solutions").should route_to("solutions#create")
    end

    it "routes to #update" do
      put("/solutions/1").should route_to("solutions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/solutions/1").should route_to("solutions#destroy", :id => "1")
    end

  end
end
