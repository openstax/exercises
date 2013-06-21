require "spec_helper"

describe QuestionDependencyPairsController do
  describe "routing" do

    it "routes to #index" do
      get("/question_dependency_pairs").should route_to("question_dependency_pairs#index")
    end

    it "routes to #new" do
      get("/question_dependency_pairs/new").should route_to("question_dependency_pairs#new")
    end

    it "routes to #show" do
      get("/question_dependency_pairs/1").should route_to("question_dependency_pairs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/question_dependency_pairs/1/edit").should route_to("question_dependency_pairs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/question_dependency_pairs").should route_to("question_dependency_pairs#create")
    end

    it "routes to #update" do
      put("/question_dependency_pairs/1").should route_to("question_dependency_pairs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/question_dependency_pairs/1").should route_to("question_dependency_pairs#destroy", :id => "1")
    end

  end
end
