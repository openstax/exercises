require "spec_helper"

describe FreeResponsesController do
  describe "routing" do

    it "routes to #index" do
      get("/free_responses").should route_to("free_responses#index")
    end

    it "routes to #new" do
      get("/free_responses/new").should route_to("free_responses#new")
    end

    it "routes to #show" do
      get("/free_responses/1").should route_to("free_responses#show", :id => "1")
    end

    it "routes to #edit" do
      get("/free_responses/1/edit").should route_to("free_responses#edit", :id => "1")
    end

    it "routes to #create" do
      post("/free_responses").should route_to("free_responses#create")
    end

    it "routes to #update" do
      put("/free_responses/1").should route_to("free_responses#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/free_responses/1").should route_to("free_responses#destroy", :id => "1")
    end

  end
end
