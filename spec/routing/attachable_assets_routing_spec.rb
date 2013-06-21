require "spec_helper"

describe AttachableAssetsController do
  describe "routing" do

    it "routes to #index" do
      get("/attachable_assets").should route_to("attachable_assets#index")
    end

    it "routes to #new" do
      get("/attachable_assets/new").should route_to("attachable_assets#new")
    end

    it "routes to #show" do
      get("/attachable_assets/1").should route_to("attachable_assets#show", :id => "1")
    end

    it "routes to #edit" do
      get("/attachable_assets/1/edit").should route_to("attachable_assets#edit", :id => "1")
    end

    it "routes to #create" do
      post("/attachable_assets").should route_to("attachable_assets#create")
    end

    it "routes to #update" do
      put("/attachable_assets/1").should route_to("attachable_assets#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/attachable_assets/1").should route_to("attachable_assets#destroy", :id => "1")
    end

  end
end
