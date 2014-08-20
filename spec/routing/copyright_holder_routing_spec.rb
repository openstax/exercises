require "spec_helper"

describe CopyrightHoldersController do
  describe "routing" do

    it "routes to #index" do
      get("/copyright_holders").should route_to("copyright_holders#index")
    end

    it "routes to #new" do
      get("/copyright_holders/new").should route_to("copyright_holders#new")
    end

    it "routes to #show" do
      get("/copyright_holders/1").should route_to("copyright_holders#show", :id => "1")
    end

    it "routes to #edit" do
      get("/copyright_holders/1/edit").should route_to("copyright_holders#edit", :id => "1")
    end

    it "routes to #create" do
      post("/copyright_holders").should route_to("copyright_holders#create")
    end

    it "routes to #update" do
      put("/copyright_holders/1").should route_to("copyright_holders#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/copyright_holders/1").should route_to("copyright_holders#destroy", :id => "1")
    end

  end
end
