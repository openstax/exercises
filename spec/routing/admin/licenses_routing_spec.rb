require "rails_helper"

module Admin
  RSpec.describe LicensesController, :type => :routing do
    describe "routing" do

      it "routes to #index" do
        expect(get("/licenses")).to route_to("licenses#index")
      end

      it "routes to #new" do
        expect(get("/licenses/new")).to route_to("licenses#new")
      end

      it "routes to #show" do
        expect(get("/licenses/1")).to route_to("licenses#show", :id => "1")
      end

      it "routes to #edit" do
        expect(get("/licenses/1/edit")).to route_to("licenses#edit", :id => "1")
      end

      it "routes to #create" do
        expect(post("/licenses")).to route_to("licenses#create")
      end

      it "routes to #update" do
        expect(put("/licenses/1")).to route_to("licenses#update", :id => "1")
      end

      it "routes to #destroy" do
        expect(delete("/licenses/1")).to route_to("licenses#destroy", :id => "1")
      end

    end
  end
end
