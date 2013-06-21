require "spec_helper"

describe MultipleChoiceAnswersController do
  describe "routing" do

    it "routes to #index" do
      get("/multiple_choice_answers").should route_to("multiple_choice_answers#index")
    end

    it "routes to #new" do
      get("/multiple_choice_answers/new").should route_to("multiple_choice_answers#new")
    end

    it "routes to #show" do
      get("/multiple_choice_answers/1").should route_to("multiple_choice_answers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/multiple_choice_answers/1/edit").should route_to("multiple_choice_answers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/multiple_choice_answers").should route_to("multiple_choice_answers#create")
    end

    it "routes to #update" do
      put("/multiple_choice_answers/1").should route_to("multiple_choice_answers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/multiple_choice_answers/1").should route_to("multiple_choice_answers#destroy", :id => "1")
    end

  end
end
