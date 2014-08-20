require "spec_helper"

module Admin
  describe GradingAlgorithmsController do
    describe "routing" do

      it "routes to #index" do
        get("/grading_algorithms").should route_to("grading_algorithms#index")
      end

      it "routes to #new" do
        get("/grading_algorithms/new").should route_to("grading_algorithms#new")
      end

      it "routes to #show" do
        get("/grading_algorithms/1").should route_to("grading_algorithms#show", :id => "1")
      end

      it "routes to #edit" do
        get("/grading_algorithms/1/edit").should route_to("grading_algorithms#edit", :id => "1")
      end

      it "routes to #create" do
        post("/grading_algorithms").should route_to("grading_algorithms#create")
      end

      it "routes to #update" do
        put("/grading_algorithms/1").should route_to("grading_algorithms#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("/grading_algorithms/1").should route_to("grading_algorithms#destroy", :id => "1")
      end

    end
  end
end
