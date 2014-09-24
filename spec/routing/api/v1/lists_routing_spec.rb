require "rails_helper"

module Api::V1
  RSpec.describe ListsController, :type => :routing do
    describe "routing" do

      it "routes to #index" do
        expect(get("/lists")).to route_to("lists#index")
      end

      it "routes to #new" do
        expect(get("/lists/new")).to route_to("lists#new")
      end

      it "routes to #show" do
        expect(get("/lists/1")).to route_to("lists#show", :id => "1")
      end

      it "routes to #edit" do
        expect(get("/lists/1/edit")).to route_to("lists#edit", :id => "1")
      end

      it "routes to #create" do
        expect(post("/lists")).to route_to("lists#create")
      end

      it "routes to #update" do
        expect(put("/lists/1")).to route_to("lists#update", :id => "1")
      end

      it "routes to #destroy" do
        expect(delete("/lists/1")).to route_to("lists#destroy", :id => "1")
      end

    end
  end
end
