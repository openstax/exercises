require "spec_helper"

describe FormatsController do
  describe "routing" do

    it "routes to #index" do
      get("/formats").should route_to("formats#index")
    end

    it "routes to #new" do
      get("/formats/new").should route_to("formats#new")
    end

    it "routes to #show" do
      get("/formats/1").should route_to("formats#show", :id => "1")
    end

    it "routes to #edit" do
      get("/formats/1/edit").should route_to("formats#edit", :id => "1")
    end

    it "routes to #create" do
      post("/formats").should route_to("formats#create")
    end

    it "routes to #update" do
      put("/formats/1").should route_to("formats#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/formats/1").should route_to("formats#destroy", :id => "1")
    end

  end
end
