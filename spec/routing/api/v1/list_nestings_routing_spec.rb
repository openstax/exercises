require "rails_helper"

module Api::V1
  RSpec.describe ListNestingsController do
    describe "routing" do

      it "routes to #index" do
        expect(:get => "/list_nestings").to route_to("list_nestings#index")
      end

      it "routes to #new" do
        expect(:get => "/list_nestings/new").to route_to("list_nestings#new")
      end

      it "routes to #show" do
        expect(:get => "/list_nestings/1").to route_to("list_nestings#show", :id => "1")
      end

      it "routes to #edit" do
        expect(:get => "/list_nestings/1/edit").to route_to("list_nestings#edit", :id => "1")
      end

      it "routes to #create" do
        expect(:post => "/list_nestings").to route_to("list_nestings#create")
      end

      it "routes to #update" do
        expect(:put => "/list_nestings/1").to route_to("list_nestings#update", :id => "1")
      end

      it "routes to #destroy" do
        expect(:delete => "/list_nestings/1").to route_to("list_nestings#destroy", :id => "1")
      end

    end
  end
end
