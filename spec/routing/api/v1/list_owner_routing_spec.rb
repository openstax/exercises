require "rails_helper"

module Api::V1
  RSpec.describe ListOwnersController do
    describe "routing" do

      it "routes to #index" do
        get("/list_owners").should route_to("list_owners#index")
      end

      it "routes to #new" do
        get("/list_owners/new").should route_to("list_owners#new")
      end

      it "routes to #show" do
        get("/list_owners/1").should route_to("list_owners#show", :id => "1")
      end

      it "routes to #edit" do
        get("/list_owners/1/edit").should route_to("list_owners#edit", :id => "1")
      end

      it "routes to #create" do
        post("/list_owners").should route_to("list_owners#create")
      end

      it "routes to #update" do
        put("/list_owners/1").should route_to("list_owners#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("/list_owners/1").should route_to("list_owners#destroy", :id => "1")
      end

    end
  end
end
