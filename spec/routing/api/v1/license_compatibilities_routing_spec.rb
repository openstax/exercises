require "rails_helper"

RSpec.describe LicenseCompatibilitiesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/license_compatibilities").to route_to("license_compatibilities#index")
    end

    it "routes to #new" do
      expect(:get => "/license_compatibilities/new").to route_to("license_compatibilities#new")
    end

    it "routes to #show" do
      expect(:get => "/license_compatibilities/1").to route_to("license_compatibilities#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/license_compatibilities/1/edit").to route_to("license_compatibilities#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/license_compatibilities").to route_to("license_compatibilities#create")
    end

    it "routes to #update" do
      expect(:put => "/license_compatibilities/1").to route_to("license_compatibilities#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/license_compatibilities/1").to route_to("license_compatibilities#destroy", :id => "1")
    end

  end
end
