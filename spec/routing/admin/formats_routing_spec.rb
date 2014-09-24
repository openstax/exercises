require "rails_helper"

module Admin
  RSpec.describe FormatsController, :type => :routing do
    describe "routing" do

      it "routes to #index" do
        expect(get("/formats")).to route_to("formats#index")
      end

      it "routes to #new" do
        expect(get("/formats/new")).to route_to("formats#new")
      end

      it "routes to #show" do
        expect(get("/formats/1")).to route_to("formats#show", :id => "1")
      end

      it "routes to #edit" do
        expect(get("/formats/1/edit")).to route_to("formats#edit", :id => "1")
      end

      it "routes to #create" do
        expect(post("/formats")).to route_to("formats#create")
      end

      it "routes to #update" do
        expect(put("/formats/1")).to route_to("formats#update", :id => "1")
      end

      it "routes to #destroy" do
        expect(delete("/formats/1")).to route_to("formats#destroy", :id => "1")
      end

    end
  end
end
