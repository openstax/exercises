require "rails_helper"

module Api::V1
  RSpec.describe LogicVariablesController, :type => :routing do
    describe "routing" do

      it "routes to #index" do
        expect(:get => "/logic_variables").to route_to("logic_variables#index")
      end

      it "routes to #new" do
        expect(:get => "/logic_variables/new").to route_to("logic_variables#new")
      end

      it "routes to #show" do
        expect(:get => "/logic_variables/1").to route_to("logic_variables#show", :id => "1")
      end

      it "routes to #edit" do
        expect(:get => "/logic_variables/1/edit").to route_to("logic_variables#edit", :id => "1")
      end

      it "routes to #create" do
        expect(:post => "/logic_variables").to route_to("logic_variables#create")
      end

      it "routes to #update" do
        expect(:put => "/logic_variables/1").to route_to("logic_variables#update", :id => "1")
      end

      it "routes to #destroy" do
        expect(:delete => "/logic_variables/1").to route_to("logic_variables#destroy", :id => "1")
      end

    end
  end
end
