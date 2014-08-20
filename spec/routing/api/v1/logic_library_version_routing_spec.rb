require "spec_helper"

module Api::V1
  describe LogicLibraryVersionsController do
    describe "routing" do

      it "routes to #index" do
        get("/logic_library_versions").should route_to("logic_library_versions#index")
      end

      it "routes to #new" do
        get("/logic_library_versions/new").should route_to("logic_library_versions#new")
      end

      it "routes to #show" do
        get("/logic_library_versions/1").should route_to("logic_library_versions#show", :id => "1")
      end

      it "routes to #edit" do
        get("/logic_library_versions/1/edit").should route_to("logic_library_versions#edit", :id => "1")
      end

      it "routes to #create" do
        post("/logic_library_versions").should route_to("logic_library_versions#create")
      end

      it "routes to #update" do
        put("/logic_library_versions/1").should route_to("logic_library_versions#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("/logic_library_versions/1").should route_to("logic_library_versions#destroy", :id => "1")
      end

    end
  end
end
