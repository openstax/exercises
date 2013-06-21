require "spec_helper"

describe TrueOrFalseAnswersController do
  describe "routing" do

    it "routes to #index" do
      get("/true_or_false_answers").should route_to("true_or_false_answers#index")
    end

    it "routes to #new" do
      get("/true_or_false_answers/new").should route_to("true_or_false_answers#new")
    end

    it "routes to #show" do
      get("/true_or_false_answers/1").should route_to("true_or_false_answers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/true_or_false_answers/1/edit").should route_to("true_or_false_answers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/true_or_false_answers").should route_to("true_or_false_answers#create")
    end

    it "routes to #update" do
      put("/true_or_false_answers/1").should route_to("true_or_false_answers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/true_or_false_answers/1").should route_to("true_or_false_answers#destroy", :id => "1")
    end

  end
end
