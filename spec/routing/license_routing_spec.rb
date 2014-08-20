require "spec_helper"

describe LicensesController do
  describe "routing" do

    it "routes to #index" do
      get("/licenses").should route_to("licenses#index")
    end

    it "routes to #new" do
      get("/licenses/new").should route_to("licenses#new")
    end

    it "routes to #show" do
      get("/licenses/1").should route_to("licenses#show", :id => "1")
    end

    it "routes to #edit" do
      get("/licenses/1/edit").should route_to("licenses#edit", :id => "1")
    end

    it "routes to #create" do
      post("/licenses").should route_to("licenses#create")
    end

    it "routes to #update" do
      put("/licenses/1").should route_to("licenses#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/licenses/1").should route_to("licenses#destroy", :id => "1")
    end

  end
end
