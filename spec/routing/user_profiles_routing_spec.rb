require "spec_helper"

describe UserProfilesController do
  describe "routing" do

    it "routes to #index" do
      get("/user_profiles").should route_to("user_profiles#index")
    end

    it "routes to #new" do
      get("/user_profiles/new").should route_to("user_profiles#new")
    end

    it "routes to #show" do
      get("/user_profiles/1").should route_to("user_profiles#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_profiles/1/edit").should route_to("user_profiles#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_profiles").should route_to("user_profiles#create")
    end

    it "routes to #update" do
      put("/user_profiles/1").should route_to("user_profiles#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_profiles/1").should route_to("user_profiles#destroy", :id => "1")
    end

  end
end
