require "rails_helper"

module Api::V1
  RSpec.describe CopyrightHolderRequestsController, :type => :routing do
    describe "routing" do

      it "routes to #index" do
        get("/copyright_holder_requests").should route_to("copyright_holder_requests#index")
      end

      it "routes to #new" do
        get("/copyright_holder_requests/new").should route_to("copyright_holder_requests#new")
      end

      it "routes to #show" do
        get("/copyright_holder_requests/1").should route_to("copyright_holder_requests#show", :id => "1")
      end

      it "routes to #edit" do
        get("/copyright_holder_requests/1/edit").should route_to("copyright_holder_requests#edit", :id => "1")
      end

      it "routes to #create" do
        post("/copyright_holder_requests").should route_to("copyright_holder_requests#create")
      end

      it "routes to #update" do
        put("/copyright_holder_requests/1").should route_to("copyright_holder_requests#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("/copyright_holder_requests/1").should route_to("copyright_holder_requests#destroy", :id => "1")
      end

    end
  end
end
