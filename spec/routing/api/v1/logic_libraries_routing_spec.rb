require "rails_helper"

module Api::V1
  RSpec.describe LogicLibrariesController, :type => :routing do
    describe "routing" do

      it "routes to #index" do
        get("/logic_libraries").should route_to("logic_libraries#index")
      end

      it "routes to #new" do
        get("/logic_libraries/new").should route_to("logic_libraries#new")
      end

      it "routes to #show" do
        get("/logic_libraries/1").should route_to("logic_libraries#show", :id => "1")
      end

      it "routes to #edit" do
        get("/logic_libraries/1/edit").should route_to("logic_libraries#edit", :id => "1")
      end

      it "routes to #create" do
        post("/logic_libraries").should route_to("logic_libraries#create")
      end

      it "routes to #update" do
        put("/logic_libraries/1").should route_to("logic_libraries#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("/logic_libraries/1").should route_to("logic_libraries#destroy", :id => "1")
      end

    end
  end
end
