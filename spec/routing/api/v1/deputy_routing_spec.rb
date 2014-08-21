require "rails_helper"

module Api::V1
  RSpec.describe DeputiesController do
    describe "routing" do

      it "routes to #index" do
        get("/deputies").should route_to("deputies#index")
      end

      it "routes to #new" do
        get("/deputies/new").should route_to("deputies#new")
      end

      it "routes to #show" do
        get("/deputies/1").should route_to("deputies#show", :id => "1")
      end

      it "routes to #edit" do
        get("/deputies/1/edit").should route_to("deputies#edit", :id => "1")
      end

      it "routes to #create" do
        post("/deputies").should route_to("deputies#create")
      end

      it "routes to #update" do
        put("/deputies/1").should route_to("deputies#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("/deputies/1").should route_to("deputies#destroy", :id => "1")
      end

    end
  end
end
