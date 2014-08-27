require "rails_helper"

RSpec.describe StaticPagesController do
  describe "routing" do

    it "routes to #index" do
      get("/static_pages").should route_to("static_pages#index")
    end

    it "routes to #new" do
      get("/static_pages/new").should route_to("static_pages#new")
    end

    it "routes to #show" do
      get("/static_pages/1").should route_to("static_pages#show", :id => "1")
    end

    it "routes to #edit" do
      get("/static_pages/1/edit").should route_to("static_pages#edit", :id => "1")
    end

    it "routes to #create" do
      post("/static_pages").should route_to("static_pages#create")
    end

    it "routes to #update" do
      put("/static_pages/1").should route_to("static_pages#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/static_pages/1").should route_to("static_pages#destroy", :id => "1")
    end

  end
end
