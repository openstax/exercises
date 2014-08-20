require "spec_helper"

describe PartsController do
  describe "routing" do

    it "routes to #index" do
      get("/parts").should route_to("parts#index")
    end

    it "routes to #new" do
      get("/parts/new").should route_to("parts#new")
    end

    it "routes to #show" do
      get("/parts/1").should route_to("parts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/parts/1/edit").should route_to("parts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/parts").should route_to("parts#create")
    end

    it "routes to #update" do
      put("/parts/1").should route_to("parts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/parts/1").should route_to("parts#destroy", :id => "1")
    end

  end
end
