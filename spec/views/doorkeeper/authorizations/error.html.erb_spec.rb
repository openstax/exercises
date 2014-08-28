require 'rails_helper'

module Doorkeeper
  RSpec.describe "authorizations/error", :type => :view do
    before(:each) do
      @authorization = assign(:authorization, Authorization.create!())
    end

    it "renders the authorization error" do
      render

      assert_select "", authorization_error_path(@authorization), "get" do
      end
    end
  end
end
