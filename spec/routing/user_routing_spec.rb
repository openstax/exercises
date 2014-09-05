require "rails_helper"

RSpec.describe UsersController, :type => :routing do
  describe "routing" do

    it "routes to #show" do
      get("/user/1").should route_to("users#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user/1/edit").should route_to("users#edit", :id => "1")
    end

    it "routes to #update" do
      put("/user").should route_to("users#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user").should route_to("users#destroy", :id => "1")
    end

  end
end
