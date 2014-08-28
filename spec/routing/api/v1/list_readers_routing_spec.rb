require "rails_helper"

module Api::V1
  RSpec.describe ListReadersController, :type => :routing do
    describe "routing" do

      it "routes to #index" do
        get("/list_readers").should route_to("list_readers#index")
      end

      it "routes to #new" do
        get("/list_readers/new").should route_to("list_readers#new")
      end

      it "routes to #show" do
        get("/list_readers/1").should route_to("list_readers#show", :id => "1")
      end

      it "routes to #edit" do
        get("/list_readers/1/edit").should route_to("list_readers#edit", :id => "1")
      end

      it "routes to #create" do
        post("/list_readers").should route_to("list_readers#create")
      end

      it "routes to #update" do
        put("/list_readers/1").should route_to("list_readers#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("/list_readers/1").should route_to("list_readers#destroy", :id => "1")
      end

    end
  end
end
