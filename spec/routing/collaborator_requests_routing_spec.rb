require "spec_helper"

describe CollaboratorRequestsController do
  describe "routing" do

    it "routes to #index" do
      get("/collaborator_requests").should route_to("collaborator_requests#index")
    end

    it "routes to #new" do
      get("/collaborator_requests/new").should route_to("collaborator_requests#new")
    end

    it "routes to #show" do
      get("/collaborator_requests/1").should route_to("collaborator_requests#show", :id => "1")
    end

    it "routes to #edit" do
      get("/collaborator_requests/1/edit").should route_to("collaborator_requests#edit", :id => "1")
    end

    it "routes to #create" do
      post("/collaborator_requests").should route_to("collaborator_requests#create")
    end

    it "routes to #update" do
      put("/collaborator_requests/1").should route_to("collaborator_requests#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/collaborator_requests/1").should route_to("collaborator_requests#destroy", :id => "1")
    end

  end
end
