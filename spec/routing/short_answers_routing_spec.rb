require "spec_helper"

describe ShortAnswersController do
  describe "routing" do

    it "routes to #index" do
      get("/short_answers").should route_to("short_answers#index")
    end

    it "routes to #new" do
      get("/short_answers/new").should route_to("short_answers#new")
    end

    it "routes to #show" do
      get("/short_answers/1").should route_to("short_answers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/short_answers/1/edit").should route_to("short_answers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/short_answers").should route_to("short_answers#create")
    end

    it "routes to #update" do
      put("/short_answers/1").should route_to("short_answers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/short_answers/1").should route_to("short_answers#destroy", :id => "1")
    end

  end
end
