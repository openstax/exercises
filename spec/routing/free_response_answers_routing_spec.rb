require "spec_helper"

describe FreeResponseAnswersController do
  describe "routing" do

    it "routes to #index" do
      get("/free_response_answers").should route_to("free_response_answers#index")
    end

    it "routes to #new" do
      get("/free_response_answers/new").should route_to("free_response_answers#new")
    end

    it "routes to #show" do
      get("/free_response_answers/1").should route_to("free_response_answers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/free_response_answers/1/edit").should route_to("free_response_answers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/free_response_answers").should route_to("free_response_answers#create")
    end

    it "routes to #update" do
      put("/free_response_answers/1").should route_to("free_response_answers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/free_response_answers/1").should route_to("free_response_answers#destroy", :id => "1")
    end

  end
end
