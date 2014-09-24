require "rails_helper"

RSpec.describe DeputizationsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get("/deputizations")).to route_to("deputizations#index")
    end

    it "routes to #new" do
      expect(get("/deputizations/new")).to route_to("deputizations#new")
    end

    it "routes to #show" do
      expect(get("/deputizations/1")).to route_to("deputizations#show", :id => "1")
    end

    it "routes to #edit" do
      expect(get("/deputizations/1/edit")).to route_to("deputizations#edit", :id => "1")
    end

    it "routes to #create" do
      expect(post("/deputizations")).to route_to("deputizations#create")
    end

    it "routes to #update" do
      expect(put("/deputizations/1")).to route_to("deputizations#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete("/deputizations/1")).to route_to("deputizations#destroy", :id => "1")
    end

  end
end
