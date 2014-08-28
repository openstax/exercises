require "rails_helper"

module Api::V1
  RSpec.describe ListEditorsController, :type => :routing do
    describe "routing" do

      it "routes to #index" do
        get("/list_editors").should route_to("list_editors#index")
      end

      it "routes to #new" do
        get("/list_editors/new").should route_to("list_editors#new")
      end

      it "routes to #show" do
        get("/list_editors/1").should route_to("list_editors#show", :id => "1")
      end

      it "routes to #edit" do
        get("/list_editors/1/edit").should route_to("list_editors#edit", :id => "1")
      end

      it "routes to #create" do
        post("/list_editors").should route_to("list_editors#create")
      end

      it "routes to #update" do
        put("/list_editors/1").should route_to("list_editors#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("/list_editors/1").should route_to("list_editors#destroy", :id => "1")
      end

    end
  end
end
