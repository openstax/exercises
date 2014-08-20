require "spec_helper"

describe QuestionFormatsController do
  describe "routing" do

    it "routes to #index" do
      get("/question_formats").should route_to("question_formats#index")
    end

    it "routes to #new" do
      get("/question_formats/new").should route_to("question_formats#new")
    end

    it "routes to #show" do
      get("/question_formats/1").should route_to("question_formats#show", :id => "1")
    end

    it "routes to #edit" do
      get("/question_formats/1/edit").should route_to("question_formats#edit", :id => "1")
    end

    it "routes to #create" do
      post("/question_formats").should route_to("question_formats#create")
    end

    it "routes to #update" do
      put("/question_formats/1").should route_to("question_formats#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/question_formats/1").should route_to("question_formats#destroy", :id => "1")
    end

  end
end
