require "rails_helper"

module Api::V1
  RSpec.describe PublicationsController, type: :routing, api: true, version: :v1 do
    describe "routing" do

      it "routes to #publish" do
        {
          'exercises' => { exercise_id: '1' },
          'community_solutions' => { community_solution_id: '1' }
        }.each do |path, params|
          expect(put("/api/#{path}/1/publish")).to(
            route_to("api/v1/publications#publish", { format: "json" }.merge(params))
          )
        end
      end

    end
  end
end
