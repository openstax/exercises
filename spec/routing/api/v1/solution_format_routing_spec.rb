require "rails_helper"

module Api::V1
  RSpec.describe SolutionFormatsController do
    describe "routing" do

      it "routes to #index" do
        get("/solution_formats").should route_to("solution_formats#index")
      end

      it "routes to #new" do
        get("/solution_formats/new").should route_to("solution_formats#new")
      end

      it "routes to #show" do
        get("/solution_formats/1").should route_to("solution_formats#show", :id => "1")
      end

      it "routes to #edit" do
        get("/solution_formats/1/edit").should route_to("solution_formats#edit", :id => "1")
      end

      it "routes to #create" do
        post("/solution_formats").should route_to("solution_formats#create")
      end

      it "routes to #update" do
        put("/solution_formats/1").should route_to("solution_formats#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("/solution_formats/1").should route_to("solution_formats#destroy", :id => "1")
      end

    end
  end
end
