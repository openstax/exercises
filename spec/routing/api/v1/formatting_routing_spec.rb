require "rails_helper"

module Api::V1
  RSpec.describe FormattingsController do
    describe "routing" do

      it "routes to #index" do
        get("/formattings").should route_to("formattings#index")
      end

      it "routes to #new" do
        get("/formattings/new").should route_to("formattings#new")
      end

      it "routes to #show" do
        get("/formattings/1").should route_to("formattings#show", :id => "1")
      end

      it "routes to #edit" do
        get("/formattings/1/edit").should route_to("formattings#edit", :id => "1")
      end

      it "routes to #create" do
        post("/formattings").should route_to("formattings#create")
      end

      it "routes to #update" do
        put("/formattings/1").should route_to("formattings#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("/formattings/1").should route_to("formattings#destroy", :id => "1")
      end

    end
  end
end
