require "rails_helper"

RSpec.describe DeputizationsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      get("/deputizations").should route_to("deputizations#index")
    end

    it "routes to #new" do
      get("/deputizations/new").should route_to("deputizations#new")
    end

    it "routes to #show" do
      get("/deputizations/1").should route_to("deputizations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/deputizations/1/edit").should route_to("deputizations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/deputizations").should route_to("deputizations#create")
    end

    it "routes to #update" do
      put("/deputizations/1").should route_to("deputizations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/deputizations/1").should route_to("deputizations#destroy", :id => "1")
    end

  end
end
