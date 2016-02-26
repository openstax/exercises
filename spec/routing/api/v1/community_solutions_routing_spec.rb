require "rails_helper"

module Api::V1
  RSpec.describe CommunitySolutionsController, type: :routing, api: true, version: :v1 do
    describe "routing" do

      it "routes to #show" do
        expect(get("/api/community_solutions/1")).to(
          route_to("api/v1/community_solutions#show", id: "1", format: "json")
        )
      end

      it "routes to #create" do
        expect(post("/api/exercises/1/questions/1/community_solutions")).to(
          route_to("api/v1/community_solutions#create", exercise_id: "1",
                                                        question_id: "1",
                                                        format: "json")
        )
      end

      it "routes to #update" do
        [:put, :patch].each do |method|
          expect(send(method, "/api/community_solutions/1")).to(
            route_to("api/v1/community_solutions#update", id: "1", format: "json")
          )
        end
      end

      it "routes to #destroy" do
        expect(delete("/api/community_solutions/1")).to(
          route_to("api/v1/community_solutions#destroy", id: "1", format: "json")
        )
      end

    end
  end
end
