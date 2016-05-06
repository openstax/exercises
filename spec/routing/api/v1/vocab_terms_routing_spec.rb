require "rails_helper"

module Api::V1
  RSpec.describe VocabTermsController, type: :routing, api: true, version: :v1 do
    describe "routing" do

      it "routes to #index" do
        expect(get("/api/vocab_terms")).to(
          route_to("api/v1/vocab_terms#index", format: "json")
        )
      end

      it "routes to #show" do
        expect(get("/api/vocab_terms/1")).to(
          route_to("api/v1/vocab_terms#show", id: "1", format: "json")
        )
      end

      it "routes to #create" do
        expect(post("/api/vocab_terms")).to(
          route_to("api/v1/vocab_terms#create", format: "json")
        )
      end

      it "routes to #update" do
        [:put, :patch].each do |method|
          expect(send(method, "/api/vocab_terms/1")).to(
            route_to("api/v1/vocab_terms#update", id: "1", format: "json")
          )
        end
      end

      it "routes to #destroy" do
        expect(delete("/api/vocab_terms/1")).to(
          route_to("api/v1/vocab_terms#destroy", id: "1", format: "json")
        )
      end

    end
  end
end
