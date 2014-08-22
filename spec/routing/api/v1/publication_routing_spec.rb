require "rails_helper"

module Api::V1
  RSpec.describe PublicationsController do
    describe "routing" do

      it "routes to #index" do
        get("/publications").should route_to("publications#index")
      end

      it "routes to #new" do
        get("/publications/new").should route_to("publications#new")
      end

      it "routes to #show" do
        get("/publications/1").should route_to("publications#show", :id => "1")
      end

      it "routes to #edit" do
        get("/publications/1/edit").should route_to("publications#edit", :id => "1")
      end

      it "routes to #create" do
        post("/publications").should route_to("publications#create")
      end

      it "routes to #update" do
        put("/publications/1").should route_to("publications#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("/publications/1").should route_to("publications#destroy", :id => "1")
      end

    end
  end
end
