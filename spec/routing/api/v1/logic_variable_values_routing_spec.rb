require "rails_helper"

module Api::V1
  RSpec.describe LogicVariableValuesController, :type => :routing do
    describe "routing" do

      it "routes to #index" do
        get("/logic_variable_values").should route_to("logic_variable_values#index")
      end

      it "routes to #new" do
        get("/logic_variable_values/new").should route_to("logic_variable_values#new")
      end

      it "routes to #show" do
        get("/logic_variable_values/1").should route_to("logic_variable_values#show", :id => "1")
      end

      it "routes to #edit" do
        get("/logic_variable_values/1/edit").should route_to("logic_variable_values#edit", :id => "1")
      end

      it "routes to #create" do
        post("/logic_variable_values").should route_to("logic_variable_values#create")
      end

      it "routes to #update" do
        put("/logic_variable_values/1").should route_to("logic_variable_values#update", :id => "1")
      end

      it "routes to #destroy" do
        delete("/logic_variable_values/1").should route_to("logic_variable_values#destroy", :id => "1")
      end

    end
  end
end
