require "spec_helper"

describe MatchingAnswersController do
  describe "routing" do

    it "routes to #index" do
      get("/matching_answers").should route_to("matching_answers#index")
    end

    it "routes to #new" do
      get("/matching_answers/new").should route_to("matching_answers#new")
    end

    it "routes to #show" do
      get("/matching_answers/1").should route_to("matching_answers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/matching_answers/1/edit").should route_to("matching_answers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/matching_answers").should route_to("matching_answers#create")
    end

    it "routes to #update" do
      put("/matching_answers/1").should route_to("matching_answers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/matching_answers/1").should route_to("matching_answers#destroy", :id => "1")
    end

  end
end
