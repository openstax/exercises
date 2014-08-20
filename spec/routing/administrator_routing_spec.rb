require "spec_helper"

describe AdministratorsController do
  describe "routing" do

    it "routes to #index" do
      get("/administrators").should route_to("administrators#index")
    end

    it "routes to #new" do
      get("/administrators/new").should route_to("administrators#new")
    end

    it "routes to #show" do
      get("/administrators/1").should route_to("administrators#show", :id => "1")
    end

    it "routes to #edit" do
      get("/administrators/1/edit").should route_to("administrators#edit", :id => "1")
    end

    it "routes to #create" do
      post("/administrators").should route_to("administrators#create")
    end

    it "routes to #update" do
      put("/administrators/1").should route_to("administrators#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/administrators/1").should route_to("administrators#destroy", :id => "1")
    end

  end
end
