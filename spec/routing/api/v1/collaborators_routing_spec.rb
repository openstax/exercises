require "rails_helper"

module Api::V1
  RSpec.describe CollaboratorsController, :type => :routing do
    describe "routing" do

      it "routes to #index" do
        get("/collaborators").should route_to("collaborators#index")
      end

      it "routes to #new" do
        get("/collaborators/new").should route_to("collaborators#new")
      end

      it "routes to #show" do
        get("/collaborators/1").should route_to("collaborators#show", :id => "1")
      end

      it "routes to #edit" do
        get("/collaborators/1/edit").should route_to("collaborators#edit", :id => "1")
      end

      it "routes to #create" do
        post("/collaborators").should route_to("collaborators#create")
      end

      it "routes to #update" do
        put("/collaborators/1").should route_to("collaborators#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("/collaborators/1").should route_to("collaborators#destroy", :id => "1")
      end

    end
  end
end
