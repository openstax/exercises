require "rails_helper"

module Api::V1
  RSpec.describe SolutionsController, :type => :routing, api: true, version: :v1 do
    describe "routing" do

      it "routes to #index" do
        expect(get("/api/exercises/1/solutions")).to(
          route_to("api/v1/solutions#index", :exercise_id => "1",
                                             :format => "json"))
      end

      it "routes to #show" do
        expect(get("/api/exercises/1/solutions/1")).to(
          route_to("api/v1/solutions#show", :id => "1",
                                            :exercise_id => "1",
                                            :format => "json"))
      end

      it "routes to #create" do
        expect(post("/api/exercises/1/solutions")).to(
          route_to("api/v1/solutions#create", :exercise_id => "1",
                                              :format => "json"))
      end

      it "routes to #update" do
        [:put, :patch].each do |method|
          expect(send(method, "/api/exercises/1/solutions/1")).to(
            route_to("api/v1/solutions#update", :id => "1",
                                                :exercise_id => "1",
                                                :format => "json"))
        end
      end

      it "routes to #destroy" do
        expect(delete("/api/exercises/1/solutions/1")).to(
          route_to("api/v1/solutions#destroy", :id => "1",
                                               :exercise_id => "1",
                                               :format => "json"))
      end

    end
  end
end
