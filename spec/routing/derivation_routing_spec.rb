require "spec_helper"

describe DerivationsController do
  describe "routing" do

    it "routes to #index" do
      get("/derivations").should route_to("derivations#index")
    end

    it "routes to #new" do
      get("/derivations/new").should route_to("derivations#new")
    end

    it "routes to #show" do
      get("/derivations/1").should route_to("derivations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/derivations/1/edit").should route_to("derivations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/derivations").should route_to("derivations#create")
    end

    it "routes to #update" do
      put("/derivations/1").should route_to("derivations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/derivations/1").should route_to("derivations#destroy", :id => "1")
    end

  end
end
