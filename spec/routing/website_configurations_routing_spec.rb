require "spec_helper"

describe WebsiteConfigurationsController do
  describe "routing" do

    it "routes to #index" do
      get("/website_configurations").should route_to("website_configurations#index")
    end

    it "routes to #new" do
      get("/website_configurations/new").should route_to("website_configurations#new")
    end

    it "routes to #show" do
      get("/website_configurations/1").should route_to("website_configurations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/website_configurations/1/edit").should route_to("website_configurations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/website_configurations").should route_to("website_configurations#create")
    end

    it "routes to #update" do
      put("/website_configurations/1").should route_to("website_configurations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/website_configurations/1").should route_to("website_configurations#destroy", :id => "1")
    end

  end
end
