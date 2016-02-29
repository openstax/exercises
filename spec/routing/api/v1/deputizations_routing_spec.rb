require "rails_helper"

module Api::V1
  RSpec.describe DeputizationsController, type: :routing, api: true, version: :v1 do
    describe "routing" do

      it "routes to #index" do
        expect(get("/api/deputies")).to(
          route_to("api/v1/deputizations#index", format: "json")
        )
      end

      it "routes to #create" do
        expect(post("/api/deputies")).to(
          route_to("api/v1/deputizations#create", format: "json")
        )
      end

      it "routes to #destroy" do
        expect(delete("/api/deputies/1")).to(
          route_to("api/v1/deputizations#destroy", id: "1", format: "json")
        )
      end

    end
  end
end
