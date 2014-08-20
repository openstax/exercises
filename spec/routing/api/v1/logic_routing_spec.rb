require "spec_helper"

module Api::V1
  describe LogicsController do
    describe "routing" do

      it "routes to #index" do
        get("/logics").should route_to("logics#index")
      end

      it "routes to #new" do
        get("/logics/new").should route_to("logics#new")
      end

      it "routes to #show" do
        get("/logics/1").should route_to("logics#show", :id => "1")
      end

      it "routes to #edit" do
        get("/logics/1/edit").should route_to("logics#edit", :id => "1")
      end

      it "routes to #create" do
        post("/logics").should route_to("logics#create")
      end

      it "routes to #update" do
        put("/logics/1").should route_to("logics#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("/logics/1").should route_to("logics#destroy", :id => "1")
      end

    end
  end
end
