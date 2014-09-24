require "rails_helper"

module Api::V1
  RSpec.describe PublicationsController, :type => :routing do
    describe "routing" do

      it "routes to #index" do
        expect(get("/publications")).to route_to("publications#index")
      end

      it "routes to #new" do
        expect(get("/publications/new")).to route_to("publications#new")
      end

      it "routes to #show" do
        expect(get("/publications/1")).to route_to("publications#show", :id => "1")
      end

      it "routes to #edit" do
        expect(get("/publications/1/edit")).to route_to("publications#edit", :id => "1")
      end

      it "routes to #create" do
        expect(post("/publications")).to route_to("publications#create")
      end

      it "routes to #update" do
        expect(put("/publications/1")).to route_to("publications#update", :id => "1")
      end

      it "routes to #destroy" do
        expect(delete("/publications/1")).to route_to("publications#destroy", :id => "1")
      end

    end
  end
end
