require 'rails_helper'

module Doorkeeper
  RSpec.describe "authorizations/new", :type => :view do
    before(:each) do
      assign(:authorization, Authorization.new())
    end

    it "renders new authorization form" do
      render

      assert_select "form[action=?][method=?]", authorizations_path, "post" do
      end
    end
  end
end
