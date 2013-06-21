require "spec_helper"

describe AssetsController do
  describe "routing" do

    it "routes to #index" do
      get("/assets").should route_to("assets#index")
    end

    it "routes to #new" do
      get("/assets/new").should route_to("assets#new")
    end

    it "routes to #show" do
      get("/assets/1").should route_to("assets#show", :id => "1")
    end

    it "routes to #edit" do
      get("/assets/1/edit").should route_to("assets#edit", :id => "1")
    end

    it "routes to #create" do
      post("/assets").should route_to("assets#create")
    end

    it "routes to #update" do
      put("/assets/1").should route_to("assets#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/assets/1").should route_to("assets#destroy", :id => "1")
    end

  end
end
