require "spec_helper"

describe UserGroupMembersController do
  describe "routing" do

    it "routes to #index" do
      get("/user_group_members").should route_to("user_group_members#index")
    end

    it "routes to #new" do
      get("/user_group_members/new").should route_to("user_group_members#new")
    end

    it "routes to #show" do
      get("/user_group_members/1").should route_to("user_group_members#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_group_members/1/edit").should route_to("user_group_members#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_group_members").should route_to("user_group_members#create")
    end

    it "routes to #update" do
      put("/user_group_members/1").should route_to("user_group_members#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_group_members/1").should route_to("user_group_members#destroy", :id => "1")
    end

  end
end
