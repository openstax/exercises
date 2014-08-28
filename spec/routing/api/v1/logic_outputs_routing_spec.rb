require "rails_helper"

module Api::V1
  RSpec.describe LogicOutputsController, :type => :routing do
    describe "routing" do

      it "routes to #index" do
        get("/logic_outputs").should route_to("logic_outputs#index")
      end

      it "routes to #new" do
        get("/logic_outputs/new").should route_to("logic_outputs#new")
      end

      it "routes to #show" do
        get("/logic_outputs/1").should route_to("logic_outputs#show", :id => "1")
      end

      it "routes to #edit" do
        get("/logic_outputs/1/edit").should route_to("logic_outputs#edit", :id => "1")
      end

      it "routes to #create" do
        post("/logic_outputs").should route_to("logic_outputs#create")
      end

      it "routes to #update" do
        put("/logic_outputs/1").should route_to("logic_outputs#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("/logic_outputs/1").should route_to("logic_outputs#destroy", :id => "1")
      end

    end
  end
end
