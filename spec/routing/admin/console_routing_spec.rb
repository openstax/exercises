require "rails_helper"

module Admin
  RSpec.describe ConsoleController, :type => :routing do
    describe "routing" do

      it "routes to #index" do
        expect(get("/")).to route_to("console#index")
      end

    end
  end
end
