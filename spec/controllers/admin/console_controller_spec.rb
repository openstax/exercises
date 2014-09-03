require "rails_helper"

module Admin
  RSpec.describe ConsoleController, type: :controller do

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # ConsoleController. Be sure to keep this updated.
    let(:valid_session) { {} }

    describe "GET index" do
      it "renders the admin console" do
        get :index, {}, valid_session
      end
    end

  end
end
