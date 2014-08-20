require "spec_helper"

describe RubricFormatsController do
  describe "routing" do

    it "routes to #index" do
      get("/rubric_formats").should route_to("rubric_formats#index")
    end

    it "routes to #new" do
      get("/rubric_formats/new").should route_to("rubric_formats#new")
    end

    it "routes to #show" do
      get("/rubric_formats/1").should route_to("rubric_formats#show", :id => "1")
    end

    it "routes to #edit" do
      get("/rubric_formats/1/edit").should route_to("rubric_formats#edit", :id => "1")
    end

    it "routes to #create" do
      post("/rubric_formats").should route_to("rubric_formats#create")
    end

    it "routes to #update" do
      put("/rubric_formats/1").should route_to("rubric_formats#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/rubric_formats/1").should route_to("rubric_formats#destroy", :id => "1")
    end

  end
end
