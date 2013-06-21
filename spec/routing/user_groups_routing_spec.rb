require "spec_helper"

describe UserGroupsController do
  describe "routing" do

    it "routes to #index" do
      get("/user_groups").should route_to("user_groups#index")
    end

    it "routes to #new" do
      get("/user_groups/new").should route_to("user_groups#new")
    end

    it "routes to #show" do
      get("/user_groups/1").should route_to("user_groups#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_groups/1/edit").should route_to("user_groups#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_groups").should route_to("user_groups#create")
    end

    it "routes to #update" do
      put("/user_groups/1").should route_to("user_groups#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_groups/1").should route_to("user_groups#destroy", :id => "1")
    end

  end
end
