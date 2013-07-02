require "spec_helper"

describe UserGroupUsersController do
  describe "routing" do

    it "routes to #index" do
      get("/user_group_users").should route_to("user_group_users#index")
    end

    it "routes to #new" do
      get("/user_group_users/new").should route_to("user_group_users#new")
    end

    it "routes to #show" do
      get("/user_group_users/1").should route_to("user_group_users#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_group_users/1/edit").should route_to("user_group_users#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_group_users").should route_to("user_group_users#create")
    end

    it "routes to #update" do
      put("/user_group_users/1").should route_to("user_group_users#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_group_users/1").should route_to("user_group_users#destroy", :id => "1")
    end

  end
end
