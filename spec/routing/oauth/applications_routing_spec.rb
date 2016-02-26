require "rails_helper"

module Oauth
  RSpec.describe ApplicationsController, type: :routing do
    describe "routing" do

      it "routes to #index" do
        expect(get("/oauth/applications")).to(
          route_to("oauth/applications#index")
        )
      end

      it "routes to #new" do
        expect(get("/oauth/applications/new")).to(
          route_to("oauth/applications#new")
        )
      end

      it "routes to #show" do
        expect(get("/oauth/applications/1")).to(
          route_to("oauth/applications#show", id: "1")
        )
      end

      it "routes to #edit" do
        expect(get("/oauth/applications/1/edit")).to(
          route_to("oauth/applications#edit", id: "1")
        )
      end

      it "routes to #create" do
        expect(post("/oauth/applications")).to(
          route_to("oauth/applications#create")
        )
      end

      it "routes to #update" do
        [:put, :patch].each do |method|
          expect(send(method, "/oauth/applications/1")).to(
            route_to("oauth/applications#update", id: "1")
          )
        end
      end

      it "routes to #destroy" do
        expect(delete("/oauth/applications/1")).to(
          route_to("oauth/applications#destroy", id: "1")
        )
      end

    end
  end
end
