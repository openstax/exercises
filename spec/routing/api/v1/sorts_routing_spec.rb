require "rails_helper"

module Api::V1
  RSpec.describe SortsController, :type => :routing do
    describe "routing" do

      it "routes to #index" do
        expect(:get => "/sorts").to route_to("sorts#index")
      end

      it "routes to #new" do
        expect(:get => "/sorts/new").to route_to("sorts#new")
      end

      it "routes to #show" do
        expect(:get => "/sorts/1").to route_to("sorts#show", :id => "1")
      end

      it "routes to #edit" do
        expect(:get => "/sorts/1/edit").to route_to("sorts#edit", :id => "1")
      end

      it "routes to #create" do
        expect(:post => "/sorts").to route_to("sorts#create")
      end

      it "routes to #update" do
        expect(:put => "/sorts/1").to route_to("sorts#update", :id => "1")
      end

      it "routes to #destroy" do
        expect(:delete => "/sorts/1").to route_to("sorts#destroy", :id => "1")
      end

    end
  end
end
