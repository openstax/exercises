require "rails_helper"

module Api::V1
  RSpec.describe ComboChoicesController do
    describe "routing" do

      it "routes to #index" do
        get("/combo_choices").should route_to("combo_choices#index")
      end

      it "routes to #new" do
        get("/combo_choices/new").should route_to("combo_choices#new")
      end

      it "routes to #show" do
        get("/combo_choices/1").should route_to("combo_choices#show", :id => "1")
      end

      it "routes to #edit" do
        get("/combo_choices/1/edit").should route_to("combo_choices#edit", :id => "1")
      end

      it "routes to #create" do
        post("/combo_choices").should route_to("combo_choices#create")
      end

      it "routes to #update" do
        put("/combo_choices/1").should route_to("combo_choices#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("/combo_choices/1").should route_to("combo_choices#destroy", :id => "1")
      end

    end
  end
end
