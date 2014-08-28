require "rails_helper"

module Admin
  RSpec.describe ClassLicensesController, :type => :routing do
    describe "routing" do

      it "routes to #index" do
        expect(:get => "/class_licenses").to route_to("class_licenses#index")
      end

      it "routes to #new" do
        expect(:get => "/class_licenses/new").to route_to("class_licenses#new")
      end

      it "routes to #show" do
        expect(:get => "/class_licenses/1").to route_to("class_licenses#show", :id => "1")
      end

      it "routes to #edit" do
        expect(:get => "/class_licenses/1/edit").to route_to("class_licenses#edit", :id => "1")
      end

      it "routes to #create" do
        expect(:post => "/class_licenses").to route_to("class_licenses#create")
      end

      it "routes to #update" do
        expect(:put => "/class_licenses/1").to route_to("class_licenses#update", :id => "1")
      end

      it "routes to #destroy" do
        expect(:delete => "/class_licenses/1").to route_to("class_licenses#destroy", :id => "1")
      end

    end
  end
end
