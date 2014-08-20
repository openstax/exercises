require "spec_helper"

module Api::V1
  describe AuthorRequestsController do
    describe "routing" do

      it "routes to #index" do
        get("/author_requests").should route_to("author_requests#index")
      end

      it "routes to #new" do
        get("/author_requests/new").should route_to("author_requests#new")
      end

      it "routes to #show" do
        get("/author_requests/1").should route_to("author_requests#show", :id => "1")
      end

      it "routes to #edit" do
        get("/author_requests/1/edit").should route_to("author_requests#edit", :id => "1")
      end

      it "routes to #create" do
        post("/author_requests").should route_to("author_requests#create")
      end

      it "routes to #update" do
        put("/author_requests/1").should route_to("author_requests#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("/author_requests/1").should route_to("author_requests#destroy", :id => "1")
      end

    end
  end
end
