require "rails_helper"

RSpec.describe UsersController, :type => :routing do
  describe "routing" do

    it "routes to #show" do
      expect(get("/user/1")).to route_to("users#show", :id => "1")
    end

    it "routes to #edit" do
      expect(get("/user/1/edit")).to route_to("users#edit", :id => "1")
    end

    it "routes to #update" do
      expect(put("/user")).to route_to("users#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete("/user")).to route_to("users#destroy", :id => "1")
    end

  end
end
