require "rails_helper"

module Admin
  RSpec.describe BaseController do
    describe "routing" do

      it "routes to #index" do
        get("/").should route_to("base#index")
      end

    end
  end
end
