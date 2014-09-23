require "rails_helper"

module Admin
  RSpec.describe TrustedApplicationsController, :type => :routing do
    describe "routing" do

      it "routes to #index" do
        expect(:get => "/trusted_applications").to route_to("trusted_applications#index")
      end

      it "routes to #new" do
        expect(:get => "/trusted_applications/new").to route_to("trusted_applications#new")
      end

      it "routes to #show" do
        expect(:get => "/trusted_applications/1").to route_to("trusted_applications#show", :id => "1")
      end

      it "routes to #edit" do
        expect(:get => "/trusted_applications/1/edit").to route_to("trusted_applications#edit", :id => "1")
      end

      it "routes to #create" do
        expect(:post => "/trusted_applications").to route_to("trusted_applications#create")
      end

      it "routes to #update" do
        expect(:put => "/trusted_applications/1").to route_to("trusted_applications#update", :id => "1")
      end

      it "routes to #destroy" do
        expect(:delete => "/trusted_applications/1").to route_to("trusted_applications#destroy", :id => "1")
      end

    end
  end
end
