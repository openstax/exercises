require "spec_helper"

module Api::V1
  describe LibraryVersionsController do
    describe "routing" do

      it "routes to #index" do
        get("/library_versions").should route_to("library_versions#index")
      end

      it "routes to #new" do
        get("/library_versions/new").should route_to("library_versions#new")
      end

      it "routes to #show" do
        get("/library_versions/1").should route_to("library_versions#show", :id => "1")
      end

      it "routes to #edit" do
        get("/library_versions/1/edit").should route_to("library_versions#edit", :id => "1")
      end

      it "routes to #create" do
        post("/library_versions").should route_to("library_versions#create")
      end

      it "routes to #update" do
        put("/library_versions/1").should route_to("library_versions#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("/library_versions/1").should route_to("library_versions#destroy", :id => "1")
      end

    end
  end
end
