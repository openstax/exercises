require "rails_helper"

module Admin
  RSpec.describe RequiredLibrariesController, :type => :routing do
    describe "routing" do

      it "routes to #index" do
        expect(:get => "/required_libraries").to route_to("required_libraries#index")
      end

      it "routes to #new" do
        expect(:get => "/required_libraries/new").to route_to("required_libraries#new")
      end

      it "routes to #show" do
        expect(:get => "/required_libraries/1").to route_to("required_libraries#show", :id => "1")
      end

      it "routes to #edit" do
        expect(:get => "/required_libraries/1/edit").to route_to("required_libraries#edit", :id => "1")
      end

      it "routes to #create" do
        expect(:post => "/required_libraries").to route_to("required_libraries#create")
      end

      it "routes to #update" do
        expect(:put => "/required_libraries/1").to route_to("required_libraries#update", :id => "1")
      end

      it "routes to #destroy" do
        expect(:delete => "/required_libraries/1").to route_to("required_libraries#destroy", :id => "1")
      end

    end
  end
end
