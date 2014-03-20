require "spec_helper"

describe AttachmentsController do
  describe "routing" do

    it "routes to #index" do
      get("/attachments").should route_to("attachments#index")
    end

    it "routes to #new" do
      get("/attachments/new").should route_to("attachments#new")
    end

    it "routes to #show" do
      get("/attachments/1").should route_to("attachments#show", :id => "1")
    end

    it "routes to #edit" do
      get("/attachments/1/edit").should route_to("attachments#edit", :id => "1")
    end

    it "routes to #create" do
      post("/attachments").should route_to("attachments#create")
    end

    it "routes to #update" do
      put("/attachments/1").should route_to("attachments#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/attachments/1").should route_to("attachments#destroy", :id => "1")
    end

  end
end
