require "rails_helper"

module Api::V1
  RSpec.describe LogicsController, :type => :routing do
    describe "routing" do

      it "routes to #index" do
        expect(get("/logics")).to route_to("logics#index")
      end

      it "routes to #new" do
        expect(get("/logics/new")).to route_to("logics#new")
      end

      it "routes to #show" do
        expect(get("/logics/1")).to route_to("logics#show", :id => "1")
      end

      it "routes to #edit" do
        expect(get("/logics/1/edit")).to route_to("logics#edit", :id => "1")
      end

      it "routes to #create" do
        expect(post("/logics")).to route_to("logics#create")
      end

      it "routes to #update" do
        expect(put("/logics/1")).to route_to("logics#update", :id => "1")
      end

      it "routes to #destroy" do
        expect(delete("/logics/1")).to route_to("logics#destroy", :id => "1")
      end

    end
  end
end
