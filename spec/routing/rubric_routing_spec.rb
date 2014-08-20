require "spec_helper"

describe RubricsController do
  describe "routing" do

    it "routes to #index" do
      get("/rubrics").should route_to("rubrics#index")
    end

    it "routes to #new" do
      get("/rubrics/new").should route_to("rubrics#new")
    end

    it "routes to #show" do
      get("/rubrics/1").should route_to("rubrics#show", :id => "1")
    end

    it "routes to #edit" do
      get("/rubrics/1/edit").should route_to("rubrics#edit", :id => "1")
    end

    it "routes to #create" do
      post("/rubrics").should route_to("rubrics#create")
    end

    it "routes to #update" do
      put("/rubrics/1").should route_to("rubrics#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/rubrics/1").should route_to("rubrics#destroy", :id => "1")
    end

  end
end
