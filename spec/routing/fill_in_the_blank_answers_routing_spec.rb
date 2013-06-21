require "spec_helper"

describe FillInTheBlankAnswersController do
  describe "routing" do

    it "routes to #index" do
      get("/fill_in_the_blank_answers").should route_to("fill_in_the_blank_answers#index")
    end

    it "routes to #new" do
      get("/fill_in_the_blank_answers/new").should route_to("fill_in_the_blank_answers#new")
    end

    it "routes to #show" do
      get("/fill_in_the_blank_answers/1").should route_to("fill_in_the_blank_answers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/fill_in_the_blank_answers/1/edit").should route_to("fill_in_the_blank_answers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/fill_in_the_blank_answers").should route_to("fill_in_the_blank_answers#create")
    end

    it "routes to #update" do
      put("/fill_in_the_blank_answers/1").should route_to("fill_in_the_blank_answers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/fill_in_the_blank_answers/1").should route_to("fill_in_the_blank_answers#destroy", :id => "1")
    end

  end
end
